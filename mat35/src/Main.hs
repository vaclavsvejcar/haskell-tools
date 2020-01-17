module Main where

import           Data.List                      ( nub )
import           Data.Maybe                     ( catMaybes )
import qualified Data.Text                     as T
import           Mat35.Core
import           Mat35.JSON
import           Mat35.Options                  ( Options(..)
                                                , optionsParser
                                                )
import           Options.Applicative            ( execParser )

main :: IO ()
main = do
  opts              <- execParser optionsParser
  urls              <- fetchURLs
  movies            <- mapM fetchMovie urls
  moviesWithTickets <- mapM fillTicketsInfo (catMaybes movies)
  let deduplicated = nub moviesWithTickets
  putStrLn . T.unpack . toJSONText (optPrettyPrint opts) $ deduplicated
