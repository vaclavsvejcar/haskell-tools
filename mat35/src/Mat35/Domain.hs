{-# LANGUAGE DeriveGeneric #-}
module Mat35.Domain where

import           Data.Aeson
import           GHC.Generics

data Screening =
  Screening { title     :: String
            , movieId   :: String
            , ticketsId :: String
            , price     :: String
            , dateTime  :: String
            } deriving (Show, Generic)

instance ToJSON Screening
