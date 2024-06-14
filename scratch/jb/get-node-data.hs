{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Control.Monad
import Data.ByteString.Char8 (ByteString)
import Data.ByteString.Char8 qualified as BS
import Data.Data
import Data.Either
import Data.Maybe (fromMaybe, mapMaybe, maybeToList)
import Data.Tuple
import Debug.Trace
import Text.ParserCombinators.ReadP qualified as P
import Text.Printf
import Text.Regex.Base
import Text.Regex.PCRE
import System.Environment

main = do
    files <- getArgs
    mapM_ (\f -> BS.putStrLn =<< getNodeTimes f) files

----------------------------------------
data Line
    = NodeStart Int
    | NodeRequest (Maybe Int)
    | NodeAbstract Double
    | NodeExtend Double
    | NodeConcretize Double
    | NodeCheckFinal Double
    | NodeCallStackChange Double
    | NodeTime Int Double
    deriving (Eq, Show, Data, Typeable)

-- legacy: selects the 'Line's that work with 'recognise' below
isPrior :: Line -> Bool
isPrior NodeStart{} = True
isPrior NodeRequest{} = True
isPrior NodeTime{} = True
isPrior _ = False

tokenise :: ByteString -> Maybe Line
tokenise input = asum $ map (uncurry tryMatch) matches
  where
    readBS :: Read a => ByteString -> a
    readBS = read . BS.unpack

    groupsFrom :: ByteString -> Maybe [ByteString]
    groupsFrom regex =
        case input =~ regex of
            ("", "", "", []) -> Nothing -- empty input
            ("", all, "", groups) | all == input -> Just groups
            (_unmatched :: (ByteString, ByteString, ByteString, [ByteString])) -> Nothing

    tryMatch :: ByteString -> ([ByteString] -> Line) -> Maybe Line
    tryMatch regex mkLine = mkLine <$> groupsFrom regex

    matches =
        [ (nodeStart, onHead $ NodeStart . readBS)
        , (nodeRequest, onHead $ NodeRequest . Just . readBS)
        , (nodeIsWasm, const $ NodeRequest Nothing)
        , (nodeTime, \(num : time : _) -> NodeTime (readBS num) (readBS time))
        , (stepTime "Abstract", onHead $ NodeAbstract . readBS)
        , (stepTime "Extend", onHead $ NodeExtend . readBS)
        , (stepTime "Concretize", onHead $ NodeConcretize . readBS)
        , (stepTime "Check final", onHead $ NodeCheckFinal . readBS)
        , (stepTime "Run call stack change", onHead $ NodeCallStackChange . readBS)
        ]

    onHead :: (a -> b) -> [a] -> b
    onHead f [] = error (show input <> ": missing argument after matching")
    onHead f [x] = f x
    onHead f (x:_) = f x -- could throw an error..

nodeStart, nodeRequest, nodeIsWasm, nodeTime, float :: ByteString
-- messages from the pythong script:
nodeStart = "^Processing ([0-9]*)$"
nodeIsWasm = "^is new wasm$"
nodeTime = "^Node ([0-9]*) took " <> float <> " sec\\.$"
float = "([0-9.]*(e[0-9-]*)?)"
-- Abstract, Extend, Concretize, Check final, Run call stack change
stepTime :: ByteString -> ByteString
stepTime prefix = "^  " <> prefix <> " " <> float <> " " <> "sec\\.$"

-- messages from proxy
nodeRequest = "^\\[proxy\\] Processing request ([0-9]*)"

----------------------------------------
-- collecting data from line sequences for a comprehensive timing

data NodeTiming =
    NodeTiming
    { nodeId :: Int
    , requests :: [Int]
    , abstract, extend, concretize, callStackChange, checkFinal :: Maybe Double
    , total :: Double
    }
    deriving (Eq, Show)

getNodeTimes :: FilePath -> IO ByteString
getNodeTimes f = do
    (ts, scrap) <- mkTimings . mapMaybe tokenise . BS.lines <$> BS.readFile f
    let errors
            | null scrap = ""
            | otherwise = "\n\nErrors:\n" <> (BS.unlines $ map (BS.pack . show) scrap)
    pure $ asTable ts <> errors


-- tab-separated rows with a header
asTable :: [NodeTiming] -> ByteString
asTable = BS.unlines . (header :) . map asRow
  where
    header =
        "NodeId  Requests       abstr   extend  concr   stackCh chkFnl  total"
     -- '23...78'23...7890123456'23...78'23...78'23...78'23...78'23...78'...
    format =
        " %3d   %15s " <> "%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f"
    asRow nt =
        BS.pack $
            printf
                format
                nt.nodeId
                (show nt.requests)
                (or0 nt.abstract)
                (or0 nt.extend)
                (or0 nt.concretize)
                (or0 nt.callStackChange)
                (or0 nt.checkFinal)
                nt.total
    or0 = fromMaybe 0.0

emptyTiming =
    NodeTiming
    { nodeId = error "undefined nodeId"
    , requests = []
    , abstract = Nothing
    , extend = Nothing
    , concretize = Nothing
    , callStackChange = Nothing
    , checkFinal = Nothing
    , total = error $ "undefined total time"
    }

mkTimings :: [Line] -> ([NodeTiming], [[Line]])
mkTimings =
    swap
    . partitionEithers
    . map timingFromSeq
    . splitOn ((== nodeTimeConstr) . toConstr)
  where
    nodeTimeConstr = toConstr $ NodeTime undefined undefined

{- sequences observed in logging samples

[NodeStart,NodeRequest,NodeCheckFinal,NodeTime]

[NodeStart,NodeRequest,NodeCallStackChange,NodeCheckFinal,NodeTime]
[NodeStart,NodeRequest,NodeCallStackChange,NodeRequest,NodeCheckFinal,NodeTime]

[NodeStart,NodeAbstract,NodeRequest,NodeExtend,NodeConcretize,NodeConcretize,NodeCheckFinal,NodeTime]
[NodeStart,NodeAbstract,NodeRequest,NodeExtend,NodeConcretize,NodeConcretize,NodeRequest,NodeCheckFinal,NodeTime]
[NodeStart,NodeAbstract,NodeRequest,NodeRequest,NodeExtend,NodeConcretize,NodeConcretize,NodeCheckFinal,NodeTime]

NB we could include Exec/Simplify request timings from the proxy here:
"^\\[proxy\\] Performed REQUESTTYPE in (" <> float <> "(ms|s))" but
then we need to adjust the log entry sequences before splitting into
NodeStart->NodeTime because they might be delayed wrt. node processing
messages from python. Sequence will always be NodeRequest
((PerformedSimplify)* PerformedExecute | PerformedImplies)
We would also need a reader for the μs, ms, s-suffixed timings.

-}
timingFromSeq :: [Line] -> Either [Line] NodeTiming
    -- sequences from above
timingFromSeq = \case
        [NodeStart nodeId
            , NodeRequest r
            , NodeCheckFinal cf
            , NodeTime nodeId' total
            ]
            | nodeId == nodeId'
              -> Right
                 emptyTiming
                 { nodeId, requests = maybeToList r, checkFinal = Just cf, total}
        [ NodeStart nodeId
            , NodeRequest r
            , NodeCallStackChange csc
            , NodeCheckFinal cf
            , NodeTime nodeId' total
            ]
            | nodeId == nodeId'
              -> Right
                 emptyTiming
                 { nodeId
                 , requests = maybeToList r
                 , callStackChange = Just csc
                 , checkFinal = Just cf
                 , total
                 }
        [NodeStart nodeId
            , NodeRequest (Just r)
            , NodeCallStackChange csc
            , NodeRequest (Just r2)
            , NodeCheckFinal cf
            , NodeTime nodeId' total
            ]
            | nodeId == nodeId'
              -> Right
                 emptyTiming
                 { nodeId
                 , requests = [r, r2]
                 , callStackChange = Just csc
                 , checkFinal = Just cf
                 , total
                 }
        [NodeStart nodeId
            , NodeAbstract abs
            , NodeRequest r
            , NodeExtend ex
            , NodeConcretize c1
            , NodeConcretize c2
            , NodeCheckFinal cf
            , NodeTime nodeId' total
            ]
            | nodeId == nodeId'
              -> Right
                 emptyTiming
                 { nodeId
                 , requests = maybeToList r
                 , abstract = Just abs
                 , extend = Just ex
                 , concretize = Just $ c1 + c2
                 , checkFinal = Just cf
                 , total
                 }
        [NodeStart nodeId
            , NodeAbstract abs
            , NodeRequest (Just r)
            , NodeExtend ex
            , NodeConcretize c1
            , NodeConcretize c2
            , NodeRequest (Just r2)
            , NodeCheckFinal cf
            , NodeTime nodeId' total
            ]
            | nodeId == nodeId'
              -> Right
                 emptyTiming
                 { nodeId
                 , requests = [r, r2]
                 , abstract = Just abs
                 , extend = Just ex
                 , concretize = Just $ c1 + c2
                 , checkFinal = Just cf
                 , total
                 }
        -- requests before extend message
        [NodeStart nodeId
            , NodeAbstract abs
            , NodeRequest (Just r)
            , NodeRequest (Just r2)
            , NodeExtend ex
            , NodeConcretize c1
            , NodeConcretize c2
            , NodeCheckFinal cf
            , NodeTime nodeId' total
            ]
            | nodeId == nodeId'
              -> Right
                 emptyTiming
                 { nodeId
                 , requests = [r, r2]
                 , abstract = Just abs
                 , extend = Just ex
                 , concretize = Just $ c1 + c2
                 , checkFinal = Just cf
                 , total
                 }
        -- something bad happened...
        [NodeStart nodeId
            , NodeTime nodeId' total
            ]
            | nodeId == nodeId'
              -> Right
                 emptyTiming
                 { nodeId
                 , total
                 }
        other -> Left other

-----------------------------------
-- helpers

splitOn :: Eq a => (a -> Bool) -> [a] -> [[a]]
splitOn sep = takeWhile (not . null) . fst . unzip . tail . iterate go . (undefined,)
    where
      -- go :: ([a], [a]) -> ([a], [a])
      go (_, []) = ([], [])
      go (_, xs) =
          let (front, back) = break sep xs
              (seps, rest) = break (not . sep) back
           in (front <> seps, rest)

----------------------------------------
-- prior art, now obsolete
getNodeTimes' :: FilePath -> IO ByteString
getNodeTimes' file =
    BS.unlines
    . processLines
    . BS.lines
    <$> BS.readFile file

processLines :: [ByteString] -> [ByteString]
processLines =
    map format . recognise . filter isPrior . mapMaybe tokenise

data Result =
    Result
    { node :: Int
    , request :: NodeRequest
    , time :: Double
    }
    deriving (Eq, Show)

data NodeRequest
    = RPCRequest Int
    | RPCRequests [Int]
    | NewWasm
    deriving (Eq, Show)

format :: Result -> ByteString
format result =
    BS.pack $ printf "%d %.02f %s" result.node result.time (show result.request)

recognise :: [Line] -> [Result]
recognise = \case
    [] ->
        []
    input@( NodeStart n : NodeRequest mbR : NodeTime n' t : rest)
        | n /= n' ->
              error $ "Node mismatch: " <> show (take 3 input)
        -- n == n'
        | Just r <- mbR ->
              Result n (RPCRequest r) t : recognise rest
        | Nothing <- mbR ->
              Result n NewWasm t : recognise rest
    input@( NodeStart n : NodeRequest (Just r) : NodeRequest (Just r') : NodeTime n' t : rest)
        | n == n' ->
              Result n (RPCRequests [r, r']) t : recognise rest
        | otherwise ->
              error $ "Node mismatch: " <> show (take 4 input)
    -- this can sometimes happen at the end.
    input@( NodeStart n : NodeRequest (Just r) : NodeRequest (Just r') : NodeRequest (Just r'') : [])
        -> Result n (RPCRequests [r, r', r'']) 0 : []

    [x1] -> []
    [x1, x2] -> []
    other ->
        error $ "Unexpected line sequence " <> show (take 4 other)
