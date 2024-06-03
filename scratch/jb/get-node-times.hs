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
    | NodeRequest (Maybe Int) ByteString
    | NodeTime Int Double
    deriving (Eq, Show)

data NodeRequest
    = Execute Int
    | ExecuteImplies Int Int
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
    input@( NodeStart n : NodeRequest mbR tipe : NodeTime n' t : rest)
        | n /= n' ->
              error $ "Node mismatch: " <> show (take 3 input)
        -- n == n'
        | tipe == "execute"
        , Just r <- mbR ->
              Result n (Execute r) t : recognise rest
        | tipe == "newWasm"
        , Nothing <- mbR ->
              Result n NewWasm t : recognise rest
        | otherwise ->
              error $ "Unexpected request type in " <> show (take 3 input)
    input@( NodeStart n : NodeRequest (Just r) "execute" : NodeRequest (Just r') "implies" : NodeTime n' t : rest)
        | n == n' ->
              Result n (ExecuteImplies r r') t : recognise rest
        | otherwise ->
              error $ "Node mismatch: " <> show (take 4 input)
    [x1] -> []
    [x1, x2] -> []
    other ->
        error $ "Unexpected line sequence " <> show (take 4 other)

tokenise :: ByteString -> Maybe Line
tokenise input
    | input =~ nodeStart =
          NodeStart . readBS . head <$> groupsFrom nodeStart
    | input =~ nodeRequest = do
          ~[num, tipe] <- groupsFrom nodeRequest
          pure $ NodeRequest (Just $ readBS num) tipe
    | input =~ nodeIsWasm =
          Just $ NodeRequest Nothing "newWasm"
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
nodeRequest = "^\\[Info\\] Process request ([0-9]*) ([a-z]*)$"
nodeIsWasm = "^is new wasm$"
nodeTime = "^Node ([0-9]*) took ([0-9.]*) sec\\.$"
