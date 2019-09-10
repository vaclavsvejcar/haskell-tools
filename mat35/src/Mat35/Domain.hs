{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
module Mat35.Domain where

import           Data.Aeson
import           GHC.Generics

data ScreeningDetail =
  ScreeningDetail { title :: String
                  , price :: String
                  , dateTime :: String
                  , allSeatsNo :: Int
                  , availableSeatsNo :: Int
                  } deriving (Show, Generic)

instance ToJSON ScreeningDetail

data Screening =
  Screening { title     :: String
            , price     :: String
            , dateTime  :: String
            , movieId   :: String
            , ticketsId :: String
            } deriving (Show, Generic)

instance ToJSON Screening
