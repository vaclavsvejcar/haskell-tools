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
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
module Mat35.Types
  ( CmdOptions(..)
  , FilmType(..)
  , Movie(..)
  , Screening(..)
  , Tickets(..)
  , MovieURL
  , TicketsURL
  )
where

import           Data.Aeson                     ( genericToJSON
                                                , ToJSON(toJSON)
                                                , Value(String)
                                                )
import qualified Data.Text                     as T
import           GHC.Generics                   ( Generic )
import           Mat35.Utils                    ( withoutPrefix )
import           System.Console.CmdArgs         ( Data
                                                , Typeable
                                                )


data CmdOptions =
    CmdOptions { prettyPrint :: Bool
               } deriving (Data, Typeable)

data FilmType = F16mm | F35mm deriving (Eq, Generic)

data Movie =
    Movie { mTitle      :: T.Text
          , mMovieURL   :: T.Text
          , mScreenings :: [Screening]
          } deriving (Generic, Show)

data Screening =
    Screening { sDateTime         :: T.Text
              , sLanguage         :: T.Text
              , sPrice            :: T.Text
              , sTicketsURL       :: TicketsURL
              , sTicketsAll       :: Int
              , sTicketsAvailable :: Int
              , sFilmType         :: FilmType
              }  deriving (Generic, Show)

data Tickets =
    Tickets { tAll       :: Int
            , tAvailable :: Int
            }

type MovieURL = T.Text
type TicketsURL = T.Text

----------------------------  TYPE CLASS INSTANCES  ----------------------------

instance Show FilmType where
  show F16mm = "16mm"
  show F35mm = "35mm"

instance ToJSON FilmType where
  toJSON = String . T.pack . show

instance ToJSON Movie where
  toJSON = genericToJSON $ withoutPrefix 1

instance ToJSON Screening where
  toJSON = genericToJSON $ withoutPrefix 1
