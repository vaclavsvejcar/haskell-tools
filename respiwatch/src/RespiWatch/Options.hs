{-# LANGUAGE NoImplicitPrelude #-}
module RespiWatch.Options where

import           Options.Applicative
import           RIO

data Options = Options
  { oInterval :: !Int
  }
  deriving (Eq, Show)

optionsParser :: ParserInfo Options
optionsParser = info
  (options <**> helper)
  (  fullDesc
  <> progDesc "check availability of Respilon respiratory protection"
  <> header "respiwatch, Copyright (c) 2020 Vaclav Svejcar"
  )
 where
  options = Options <$> option
    auto
    (long "interval" <> short 'i' <> metavar "INT" <> help
      "set the interval of check"
    )
