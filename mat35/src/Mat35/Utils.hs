module Mat35.Utils where

import           Data.Aeson                     ( defaultOptions
                                                , fieldLabelModifier
                                                , Options
                                                )
import           Data.Char                      ( toLower )

withoutPrefix :: Int -> Options
withoutPrefix len = defaultOptions { fieldLabelModifier = dropPrefix len }
 where
  dropPrefix pLen str = firstToLower $ drop pLen str

  firstToLower []      = []
  firstToLower (h : t) = toLower h : t
