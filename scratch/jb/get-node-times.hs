{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad
import Data.ByteString.Char8 (ByteString)
import Data.ByteString.Char8 qualified as BS
import Data.Maybe (mapMaybe)
import Text.Printf
import Text.Regex.Base
import Text.Regex.PCRE
import System.Environment

main = do
    files <- getArgs
    mapM_ (\f -> BS.putStrLn =<< getNodeTimes f) files

getNodeTimes :: FilePath -> IO ByteString
getNodeTimes file =
    BS.unlines
    . processLines
    . BS.lines
    <$> BS.readFile file

processLines :: [ByteString] -> [ByteString]
processLines = map format . recognise . mapMaybe tokenise

data Line
    = NodeStart Int
    | NodeRequest (Maybe Int)
    | NodeTime Int Double
    deriving (Eq, Show)

data NodeRequest
    = RPCRequest Int
    | RPCRequests [Int]
    | NewWasm
    deriving (Eq, Show)

data Result =
    Result
    { node :: Int
    , request :: NodeRequest
    , time :: Double
    }
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

tokenise :: ByteString -> Maybe Line
tokenise input
    | input =~ nodeStart =
          NodeStart . readBS . head <$> groupsFrom nodeStart
    | input =~ nodeRequest = do
          ~[num] <- groupsFrom nodeRequest
          pure $ NodeRequest (Just $ readBS num)
    | input =~ nodeIsWasm =
          Just $ NodeRequest Nothing
    | input =~ nodeTime = do
          ~[num, time] <- groupsFrom nodeTime
          pure $ NodeTime (readBS num) (readBS time)
    | otherwise = Nothing

  where
    readBS :: Read a => ByteString -> a
    readBS = read . BS.unpack

    groupsFrom :: ByteString -> Maybe [ByteString]
    groupsFrom regex =
        case input =~ regex of
            ("", _all, "", groups) -> Just groups
            (_unmatched :: (ByteString, ByteString, ByteString, [ByteString])) -> Nothing

nodeStart, nodeRequest, nodeIsWasm, nodeTime :: ByteString
nodeStart = "^Processing ([0-9]*)$"
nodeRequest = "^\\[proxy\\] Processing request ([0-9]*)"
nodeIsWasm = "^is new wasm$"
nodeTime = "^Node ([0-9]*) took ([0-9.]*) sec\\.$"
