module Mat35.JSON
  ( toJSONText
  )
where

import           Data.Aeson
import           Data.Aeson.Encode.Pretty
import qualified Data.ByteString.Lazy          as BL
import           Data.Text                      ( Text )
import qualified Data.Text.Encoding            as E


toJSONText :: ToJSON a => Bool -> a -> Text
toJSONText pretty = E.decodeUtf8 . BL.toStrict . encodeJSON
  where encodeJSON = if pretty then encodePretty else encode
