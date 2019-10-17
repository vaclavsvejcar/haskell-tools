{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
module Mat35.API where

import qualified Data.Text                     as T
import           Data.Maybe                     ( fromMaybe )
import           Mat35.Types                    ( Movie(..)
                                                , Screening(..)
                                                , Tickets(..)
                                                , MovieURL
                                                , TicketsURL
                                                )
import           Mat35.URLs                     ( rootURL
                                                , screeningsPageURL
                                                )
import           Text.HTML.Scalpel

fetchMovie :: MovieURL -> IO (Maybe Movie)
fetchMovie url = scrapeURLWithConfig utf8Config (T.unpack url) movie
 where
  movie :: Scraper T.Text Movie
  movie = chroot ("div" @: [hasClass "rent1"]) $ do
    screenings <- chroots ("table" @: [hasClass "cinematab"] // "tr") screening
    title      <- text "h2"
    return $ Movie title url screenings

  screening :: Scraper T.Text Screening
  screening = inSerial $ do
    date       <- seekNext $ text "td"
    time       <- seekNext $ text "td"
    language   <- seekNext $ text "td"
    price      <- seekNext $ text "td"
    ticketsURL <- seekNext $ attr "href" $ "td" // "a"
    let dateTime = date <> " " <> time
    return $ Screening dateTime language price ticketsURL 0 0

fetchTickets :: TicketsURL -> IO (Maybe Tickets)
fetchTickets url = scrapeURLWithConfig utf8Config (T.unpack url) tickets
 where
  tickets :: Scraper T.Text Tickets
  tickets = do
    let seatsS      = "div" @: ["id" @= "hladisko"]
    let allSeatsS   = "path" @: [hasClass "seat"]
    let availSeatsS = "path" @: [hasClass "seat", notP ("fill" @= "#fff")]
    allSeats   <- htmls $ seatsS // allSeatsS
    availSeats <- htmls $ seatsS // availSeatsS
    let allSeatsNo   = length allSeats
    let availSeatsNo = allSeatsNo - length availSeats
    return $ Tickets allSeatsNo availSeatsNo

fetchURLs :: IO [MovieURL]
fetchURLs = fmap (fromMaybe [])
                 (scrapeURLWithConfig utf8Config screeningsPageURL movies)
 where
  movies :: Scraper T.Text [MovieURL]
  movies = chroots ("div" @: [hasClass "cinema"]) movie

  movie :: Scraper T.Text MovieURL
  movie = do
    link <- attr "href" $ "div" @: [hasClass "cinema123"] // "a"
    return $ T.pack rootURL <> link

fillTicketsInfo :: Movie -> IO Movie
fillTicketsInfo movie = do
  screeningsWithTickets <- mapM fillTickets (mScreenings movie)
  return $ movie { mScreenings = screeningsWithTickets }
 where
  fillTickets :: Screening -> IO Screening
  fillTickets screening = do
    maybeTickets <- fetchTickets (sTicketsURL screening)
    return $ case maybeTickets of
      Nothing      -> screening
      Just tickets -> screening { sTicketsAll       = tAll tickets
                                , sTicketsAvailable = tAvailable tickets
                                }

utf8Config :: Config T.Text
utf8Config = Config utf8Decoder Nothing
