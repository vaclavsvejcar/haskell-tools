{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Mat35.Domain
import           Mat35.Scraper

main :: IO ()
main = do
  screenings <- fetchScreenings
  maybe printError (printResult . map show) screenings
 where
  printError  = putStrLn "ERROR: cannot fetch screenings"
  printResult = mapM_ putStrLn
