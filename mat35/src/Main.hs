{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Text                     as T
import qualified Data.Text.IO                  as T
import           Mat35.Scraper

main :: IO ()
main = do
  screenings <- fetchScreenings
  maybe printError printResult screenings
 where
  printError  = putStrLn "ERROR: cannot fetch screenings"
  printResult = mapM_ T.putStrLn
