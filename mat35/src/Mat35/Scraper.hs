{-# LANGUAGE OverloadedStrings #-}
module Mat35.Scraper
  ( fetchScreenings
  )
where

import           Data.List.Split
import           Data.Maybe
import           Mat35.Domain
import           Mat35.URLs
import           Text.HTML.Scalpel

fetchScreenings :: IO (Maybe [Screening])
fetchScreenings = scrapeURLWithConfig config screeningsURL screenings
 where
  config = Config utf8Decoder Nothing

  screenings :: Scraper String [Screening]
  screenings = chroots ("div" @: [hasClass "cinema"]) screening

  screening :: Scraper String Screening
  screening = do
    date        <- text $ "div" @: [hasClass "cinema121"]
    time        <- text $ "div" @: [hasClass "cinema122"]
    title       <- text $ "div" @: [hasClass "cinema123"] // "a"
    detailPath  <- attr "href" $ "div" @: [hasClass "cinema123"] // "a"
    ticketsLink <- attr "href" $ "div" @: [hasClass "cinema124"] // "a"
    price       <- text $ "div" @: [hasClass "cinema124"] // "strong"

    let movieId   = splitOn "?movie-id=" detailPath !! 1
    let ticketsId = splitOn "?id=" ticketsLink !! 1

    return $ Screening title movieId ticketsId price (date ++ " " ++ time)
