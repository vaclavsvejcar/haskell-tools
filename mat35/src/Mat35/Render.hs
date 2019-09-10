module Mat35.Render where

import           Data.Aeson.Text
import           Data.ByteString.Lazy.Char8
import qualified Data.Text                     as T
import qualified Data.Text.Lazy                as TL
import           Mat35.Domain

render :: [ScreeningMeta] -> String
render = T.unpack . TL.toStrict . encodeToLazyText
