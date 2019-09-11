module Mat35.Render where

import           Data.Aeson
import           Data.Aeson.Encode.Pretty
import           Data.ByteString.Lazy          as BL
import qualified Data.Text                     as T
import qualified Data.Text.Encoding            as E
import           Mat35.Domain.ScreeningDetail

render :: [ScreeningDetail] -> Bool -> String
render ds pretty = T.unpack . E.decodeUtf8 . BL.toStrict . encodeJSON $ ds
  where encodeJSON = if pretty then encodePretty else encode
