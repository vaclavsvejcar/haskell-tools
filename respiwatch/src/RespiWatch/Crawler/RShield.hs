{-# LANGUAGE NoImplicitPrelude #-}
module RespiWatch.Crawler.RShield where

import           RIO
import           Text.HTML.Scalpel
import           RespiWatch.Env                 ( HasPaths(..)
                                                , Paths(..)
                                                )
import qualified RIO.Text                      as T

allSoldOut :: (HasPaths env) => RIO env (Maybe Bool)
allSoldOut = do
  paths <- view pathsL
  liftIO
    $ scrapeURLWithConfig utf8Config (T.unpack . pRShieldURL $ paths) scraper
  where scraper = undefined

utf8Config :: Config Text
utf8Config = Config utf8Decoder Nothing
