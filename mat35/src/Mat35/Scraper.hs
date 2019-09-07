{-# LANGUAGE OverloadedStrings #-}
module Mat35.Scraper where

import           Data.Maybe
import           Text.HTML.Scalpel

siteURL = "http://www.mat.cz/kino/cz/cykly?action=projekce-z-filmoveho-pasu"

fetchScreenings :: IO (Maybe [String])
fetchScreenings = scrapeURLWithConfig config siteURL screenings
 where
  config = Config utf8Decoder Nothing

  screenings :: Scraper String [String]
  screenings = chroots ("div" @: [hasClass "cinema"]) screening

  screening :: Scraper String String
  screening = do
    date <- text $ "div" @: [hasClass "cinema121"]
    time <- text $ "div" @: [hasClass "cinema122"]
    title <- text $ "div" @: [hasClass "cinema123"] // "a"
    link <- attr "href" $ "div" @: [hasClass "cinema123"] // "a"
    price <- text $ "div" @: [hasClass "cinema124"] // "strong"
    return $ date ++ " | " ++ time ++ " | " ++ title ++ " | " ++ link ++ " | " ++ price
