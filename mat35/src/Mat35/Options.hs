module Mat35.Options
  ( Options(..)
  , optionsParser
  )
where

import           Data.Semigroup                 ( (<>) )
import           Mat35.Utils                    ( buildVer )
import           Options.Applicative

newtype Options = Options
  { oPrettyPrint :: Bool
  }
  deriving (Eq, Show)

optionsParser :: ParserInfo Options
optionsParser = info
  (options <**> helper)
  (  fullDesc
  <> progDesc "fetch 35mm film screenings from MAT cinema website"
  <> header
       ("mat35 v" <> buildVer <> ", Copyright (c) 2019-2020 Vaclav Svejcar")
  )
 where
  options = Options <$> switch
    (long "pretty-print" <> short 'p' <> help "pretty print the output JSON")

