{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Mat35.Render
import           Mat35.Scraper

main :: IO ()
main = do
  screenings <- fetchScreenings
  details    <- fmap sequenceA . mapM fetchDetail . concat $ screenings
  maybe printError printResult details
 where
  printError  = putStrLn "ERROR: unknown failure, cannot fetch screenings"
  printResult = putStrLn . render
