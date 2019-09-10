{-# LANGUAGE DeriveGeneric #-}
module Mat35.Domain where

import           Data.Aeson
import           GHC.Generics

data ScreeningMeta =
  ScreeningMeta { title     :: String
                , movieId   :: String
                , ticketsId :: String
                , price     :: String
                , dateTime  :: String
                } deriving (Show, Generic)

instance ToJSON ScreeningMeta
