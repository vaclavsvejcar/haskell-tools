{-# LANGUAGE FlexibleContexts, OverloadedStrings, QuasiQuotes #-}
module Mat35.Scraper
  ( fetchScreenings
  )
where

import           Data.List.Split
import           Data.Maybe
import           Mat35.Domain
import           Mat35.URLs
import           Text.HTML.Scalpel
import           Text.Regex.PCRE.Heavy

fetchScreenings :: IO (Maybe [ScreeningMeta])
fetchScreenings = scrapeURLWithConfig config screeningsURL screenings
 where
  config = Config utf8Decoder Nothing

  screenings :: Scraper String [ScreeningMeta]
  screenings = chroots ("div" @: [hasClass "cinema"]) screening

  screening :: Scraper String ScreeningMeta
  screening = do
    date        <- text $ "div" @: [hasClass "cinema121"]
    time        <- text $ "div" @: [hasClass "cinema122"]
    title       <- text $ "div" @: [hasClass "cinema123"] // "a"
    detailPath  <- attr "href" $ "div" @: [hasClass "cinema123"] // "a"
    ticketsLink <- attr "href" $ "div" @: [hasClass "cinema124"] // "a"
    price       <- text $ "div" @: [hasClass "cinema124"] // "strong"

    let movieId   = splitOn "?movie-id=" detailPath !! 1
    let ticketsId = splitOn "?id=" ticketsLink !! 1
    let dateTime  = parseDate date ++ ", " ++ time

    return $ ScreeningMeta title movieId ticketsId price dateTime

parseDate :: String -> String
parseDate raw =
  let (_, groups) = head $ scan [re|(.*?)(\d+)(.*)|] raw in unwords groups
