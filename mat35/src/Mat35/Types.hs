{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
module Mat35.Types
  ( CmdOptions(..)
  , Movie(..)
  , Screening(..)
  , Tickets(..)
  , MovieURL
  , TicketsURL
  )
where

import           Data.Aeson                     ( genericToJSON
                                                , ToJSON(toJSON)
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
              }  deriving (Generic, Show)

data Tickets =
    Tickets { tAll       :: Int
            , tAvailable :: Int
            }

type MovieURL = T.Text
type TicketsURL = T.Text

--------------------------------------------------------------------------------

instance ToJSON Movie where
  toJSON = genericToJSON $ withoutPrefix 1

instance ToJSON Screening where
  toJSON = genericToJSON $ withoutPrefix 1
