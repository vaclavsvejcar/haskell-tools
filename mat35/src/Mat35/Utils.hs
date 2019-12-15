{-|
Module      : <MODULE_NAME>
Description : <DESCRIPTION>
Copyright   : 
License     : BSD-3
Maintainer  : 
Stability   : experimental
Portability : POSIX

 <LONGER_DESCRIPTION>
-}
module Mat35.Utils
  ( buildVer
  , withoutPrefix
  )
where

import           Data.Aeson                     ( defaultOptions
                                                , fieldLabelModifier
                                                , Options
                                                )
import           Data.Char                      ( toLower )
import           Data.Version                   ( showVersion )
import           Paths_mat35                    ( version )

withoutPrefix :: Int -> Options
withoutPrefix len = defaultOptions { fieldLabelModifier = dropPrefix len }
 where
  dropPrefix pLen str = firstToLower $ drop pLen str

  firstToLower []      = []
  firstToLower (h : t) = toLower h : t

buildVer :: String
buildVer = showVersion version
