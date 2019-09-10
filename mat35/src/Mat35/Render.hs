module Mat35.Render where

import           Data.Aeson.Text
import qualified Data.Text                     as T
import qualified Data.Text.Lazy                as TL
import Mat35.Domain.ScreeningDetail

render :: [ScreeningDetail] -> String
render = T.unpack . TL.toStrict . encodeToLazyText
