{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module RespiWatch.Main where

import           RIO

run :: (HasLogFunc env) => RIO env ()
run = do
  logInfo "todo"
