{-# LANGUAGE DeriveGeneric #-}
module Mat35.Types
  ( FilmType(..)
  , Movie(..)
  , Screening(..)
  , Tickets(..)
  , MovieURL
  , TicketsURL
  )
where

import           Data.Aeson                     ( ToJSON(toJSON)
                                                , Value(String)
                                                , genericToJSON
                                                )
import           Data.Text                      ( Text )
import qualified Data.Text                     as T

import           GHC.Generics                   ( Generic )
import           Mat35.Utils                    ( withoutPrefix )

data FilmType = F16mm | F35mm deriving (Eq, Generic)

data Movie = Movie
  { mTitle      :: Text
  , mMovieURL   :: Text
  , mScreenings :: [Screening]
  }
  deriving (Eq, Generic, Show)

data Screening = Screening
  { sDateTime         :: Text
  , sLanguage         :: Text
  , sPrice            :: Text
  , sTicketsURL       :: TicketsURL
  , sTicketsAll       :: Int
  , sTicketsAvailable :: Int
  , sFilmType         :: FilmType
  }
  deriving (Eq, Generic, Show)

data Tickets = Tickets
  { tAll       :: Int
  , tAvailable :: Int
  }
  deriving (Eq, Show)

type MovieURL = Text
type TicketsURL = Text

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
