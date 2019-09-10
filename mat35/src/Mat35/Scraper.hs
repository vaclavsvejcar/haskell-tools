{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
module Mat35.Scraper
  ( fetchDetail
  , fetchScreenings
  )
where

import           Data.List.Split
import           Data.Maybe
import           Mat35.Domain
import           Mat35.URLs
import           Text.HTML.Scalpel
import           Text.Regex.PCRE.Heavy

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
    let dateTime  = parseDate date ++ ", " ++ time

    return $ Screening title price dateTime movieId ticketsId

fetchDetail :: Screening -> IO (Maybe ScreeningDetail)
fetchDetail s = scrapeURLWithConfig config (ticketsURL (ticketsId s)) detail
 where
  config = Config utf8Decoder Nothing

  detail :: Scraper String ScreeningDetail
  detail = do
    let seatsS      = "div" @: ["id" @= "hladisko"]
    let allSeatsS   = "path" @: [hasClass "seat"]
    let availSeatsS = "path" @: [hasClass "seat", notP ("fill" @= "#fff")]

    allSeats   <- htmls $ seatsS // allSeatsS
    availSeats <- htmls $ seatsS // availSeatsS

    let sTitle    = title (s :: Screening)
    let sPrice    = price (s :: Screening)
    let sDateTime = dateTime (s :: Screening)
    let detailURL = movieURL (movieId (s :: Screening))
    let allNo     = length allSeats
    let availNo   = allNo - length availSeats

    return $ ScreeningDetail sTitle sPrice sDateTime detailURL allNo availNo

parseDate :: String -> String
parseDate raw =
  let (_, groups) = head $ scan [re|(.*?)(\d+)(.*)|] raw in unwords groups
