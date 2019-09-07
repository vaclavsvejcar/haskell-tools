{-# LANGUAGE OverloadedStrings #-}
module Mat35.Scraper where

import           Data.Text
import           Data.Maybe
import           Text.HTML.Scalpel

siteURL = "http://www.mat.cz/kino/cz/cykly?action=projekce-z-filmoveho-pasu"

fetchScreenings :: IO (Maybe [Text])
fetchScreenings = scrapeURLWithConfig config siteURL screenings
 where
  config = Config utf8Decoder Nothing
  screenings :: Scraper Text [Text]
  screenings = texts $ "div" @: [hasClass "cinema"]
