{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.Maybe                     ( catMaybes )
import qualified Data.Text                     as T
import           Mat35.API
import           Mat35.JSON                     ( toJSONText )
import           Mat35.Types                    ( CmdOptions(..) )
import           System.Console.CmdArgs


-- data Options = Options { prettyPrint :: Bool } deriving (Data, Typeable)

options :: CmdOptions
options =
  CmdOptions { prettyPrint = False &= help "Pretty print the output JSON" }
    &= summary "mat35 v0.1.0, Copyright (c) 2019 Vaclav Svejcar"
    &= program "mat35"

main :: IO ()
main = do
  opts              <- cmdArgs options
  urls              <- fetchURLs
  movies            <- mapM fetchMovie urls
  moviesWithTickets <- mapM fillTicketsInfo (catMaybes movies)
  putStrLn . T.unpack . toJSONText (prettyPrint opts) $ moviesWithTickets
