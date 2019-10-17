module Mat35.JSON
  ( toJSONText
  )
where

import           Data.Aeson
import           Data.Aeson.Encode.Pretty
import qualified Data.ByteString.Lazy          as BL
import qualified Data.Text                     as T
import qualified Data.Text.Encoding            as E


toJSONText :: ToJSON a => Bool -> a -> T.Text
toJSONText pretty = E.decodeUtf8 . BL.toStrict . encodeJSON
  where encodeJSON = if pretty then encodePretty else encode
