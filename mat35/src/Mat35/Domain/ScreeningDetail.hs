{-# LANGUAGE DeriveGeneric #-}
module Mat35.Domain.ScreeningDetail where

import           Data.Aeson
import           GHC.Generics

data ScreeningDetail =
  New { title          :: String
      , price          :: String
      , dateTime       :: String
      , detailURL      :: String
      , allSeats       :: Int
      , availableSeats :: Int
      } deriving (Show, Generic)

instance ToJSON ScreeningDetail
