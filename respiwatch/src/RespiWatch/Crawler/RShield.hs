{-# LANGUAGE NoImplicitPrelude #-}
module RespiWatch.Crawler.RShield where

import           RIO
import           Text.HTML.Scalpel

utf8Config :: Config Text
utf8Config = Config utf8Decoder Nothing
