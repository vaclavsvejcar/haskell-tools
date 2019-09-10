{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
module Mat35.Scraper
  ( fetchDetail
  , fetchScreenings
  )
where

import           Data.List.Split
import qualified Mat35.Domain.Screening        as Screening
import qualified Mat35.Domain.ScreeningDetail  as ScreeningDetail
import           Mat35.Domain.Screening         ( Screening )
import           Mat35.Domain.ScreeningDetail   ( ScreeningDetail )
import           Mat35.URLs
import           Text.HTML.Scalpel
import           Text.Regex.PCRE.Heavy

fetchScreenings :: IO (Maybe [Screening])
fetchScreenings = scrapeURLWithConfig utf8Config screeningsURL screenings
 where
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

    return $ Screening.New title price dateTime movieId ticketsId

fetchDetail :: Screening -> IO (Maybe ScreeningDetail)
fetchDetail s = scrapeURLWithConfig utf8Config url detail
 where
  url = ticketsURL (Screening.ticketsId s)

  detail :: Scraper String ScreeningDetail
  detail = do
    let seatsS      = "div" @: ["id" @= "hladisko"]
    let allSeatsS   = "path" @: [hasClass "seat"]
    let availSeatsS = "path" @: [hasClass "seat", notP ("fill" @= "#fff")]

    allSeats   <- htmls $ seatsS // allSeatsS
    availSeats <- htmls $ seatsS // availSeatsS

    let allSeatsNo = length allSeats
    return $ ScreeningDetail.New (Screening.title s)
                                 (Screening.price s)
                                 (Screening.dateTime s)
                                 (movieURL . Screening.movieId $ s)
                                 allSeatsNo
                                 (allSeatsNo - length availSeats)

utf8Config :: Config String
utf8Config = Config utf8Decoder Nothing

parseDate :: String -> String
parseDate raw =
  let (_, groups) = head $ scan [re|(.*?)(\d+)(.*)|] raw in unwords groups
