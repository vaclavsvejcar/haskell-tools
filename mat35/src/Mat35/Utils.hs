{-# LANGUAGE LambdaCase #-}
module Mat35.Utils
  ( buildVer
  , withoutPrefix
  )
where

import           Data.Aeson                     ( Options
                                                , defaultOptions
                                                , fieldLabelModifier
                                                )
import           Data.Char                      ( toLower )
import           Data.Version                   ( showVersion )
import           Paths_mat35                    ( version )

withoutPrefix :: Int -> Options
withoutPrefix len = defaultOptions { fieldLabelModifier = dropPrefix len }
 where
  dropPrefix pLen str = firstToLower $ drop pLen str
  firstToLower = \case
    []      -> []
    (h : t) -> toLower h : t

buildVer :: String
buildVer = showVersion version
