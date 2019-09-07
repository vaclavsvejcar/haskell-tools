{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Mat35.Domain
import Mat35.Render
import           Mat35.Scraper

main :: IO ()
main = do
  screenings <- fetchScreenings
  maybe printError printResult screenings
 where
  printError  = putStrLn "ERROR: cannot fetch screenings"

  printResult :: [Screening] -> IO ()
  printResult s = putStrLn $ render s
