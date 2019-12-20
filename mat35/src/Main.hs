{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.List                      ( nub )
import           Data.Maybe                     ( catMaybes )
import qualified Data.Text                     as T
import           Mat35.Core
import           Mat35.JSON
import           Mat35.Types                    ( CmdOptions(..) )
import           Mat35.Utils                    ( buildVer )
import           System.Console.CmdArgs

options :: CmdOptions
options =
  CmdOptions { prettyPrint = False &= help "Pretty print the output JSON" }
    &= summary ("mat35 v" ++ buildVer ++ ", Copyright (c) 2019 Vaclav Svejcar")
    &= program "mat35"

main :: IO ()
main = do
  opts              <- cmdArgs options
  urls              <- fetchURLs
  movies            <- mapM fetchMovie urls
  moviesWithTickets <- mapM fillTicketsInfo (catMaybes movies)
  let deduplicated = nub moviesWithTickets
  putStrLn . T.unpack . toJSONText (prettyPrint opts) $ deduplicated
