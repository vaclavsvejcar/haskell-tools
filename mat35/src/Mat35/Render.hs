module Mat35.Render where

import Data.Aeson
import Data.ByteString.Lazy.Char8
import Mat35.Domain

render :: [Screening] -> String
render screenings = unpack $ encode screenings