{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Options.Applicative            ( execParser )
import           Prelude                        ( putStrLn )
import           RespiWatch.Env                 ( Env(..)
                                                , Paths(..)
                                                )
import           RespiWatch.Main                ( run )
import           RespiWatch.Options             ( Options(..)
                                                , optionsParser
                                                )
import           RIO

main :: IO ()
main = do
  opts       <- execParser optionsParser
  logOptions <- logOptionsHandle stdout False
  withLogFunc logOptions $ \logFunc -> do
    let env = Env { envLogFunc = logFunc, envOptions = opts, envPaths = paths }
    runRIO env run

paths :: Paths
paths = Paths { pRShieldURL = "https://shop.respilon.com/r-shield/" }
