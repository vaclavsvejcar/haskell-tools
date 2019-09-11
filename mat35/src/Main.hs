{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Mat35.Render
import           Mat35.Scraper
import           System.Console.CmdArgs

data Options = Options { prettyPrint :: Bool } deriving (Data, Typeable)

options :: Options
options =
  Options { prettyPrint = False &= help "Pretty print the output JSON" }
    &= summary "mat35 v0.1.0, Copyright (c) 2019 Vaclav Svejcar"
    &= program "mat35"

main :: IO ()
main = do
  opts             <- cmdArgs options
  screenings       <- fetchScreenings
  screeningDetails <- fmap sequenceA . mapM fetchDetail . concat $ screenings
  maybe printError (printResult $ prettyPrint opts) screeningDetails
 where
  printError = putStrLn "ERROR: unknown failure, cannot fetch screenings"
  printResult bs ds = putStrLn (render ds bs)
