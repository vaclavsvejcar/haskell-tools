{-# LANGUAGE DeriveGeneric #-}
module Mat35.Domain.Screening where

import           Data.Aeson
import           GHC.Generics

data Screening =
  New { title     :: String
      , price     :: String
      , dateTime  :: String
      , movieId   :: String
      , ticketsId :: String
      } deriving (Show, Generic)

instance ToJSON Screening
