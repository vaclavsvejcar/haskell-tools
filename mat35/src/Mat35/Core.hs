{-|
Module      : <MODULE_NAME>
Description : <DESCRIPTION>
Copyright   : 
License     : BSD-3
Maintainer  : 
Stability   : experimental
Portability : POSIX

 <LONGER_DESCRIPTION>
-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
module Mat35.Core
  ( fetchMovie
  , fetchURLs
  , fillTicketsInfo
  )
where

import qualified Data.Text                     as T
import           Data.Maybe                     ( catMaybes
                                                , fromMaybe
                                                )
import           Mat35.Types
import           Mat35.URLs
import           Text.HTML.Scalpel


fetchMovie :: MovieURL -> IO (Maybe Movie)
fetchMovie url = scrapeURLWithConfig utf8Config (T.unpack url) movie
 where
  movie :: Scraper T.Text Movie
  movie = chroot ("div" @: [hasClass "rent1"]) $ do
    screenings <- chroots ("table" @: [hasClass "cinematab"] // "tr") screening
    title      <- text "h2"
    return $ Movie title url (catMaybes screenings)

  screening :: Scraper T.Text (Maybe Screening)
  screening = inSerial $ do
    date                 <- seekNext $ text "td"
    time                 <- seekNext $ text "td"
    (language, filmType) <- seekNext $ do
      language <- text "td"
      tags16mm <- attrs "alt" $ "td" // "img" @: ["alt" @= "16mm film"]
      tags35mm <- attrs "alt" $ "td" // "img" @: ["alt" @= "35mm film"]
      return (language, parseFilmType $ tags16mm ++ tags35mm)
    price      <- seekNext $ text "td"
    ticketsURL <- seekNext $ attr "href" $ "td" // "a"
    let dateTime = date <> " " <> time
    return $ fmap (Screening dateTime language price ticketsURL 0 0) filmType


  parseFilmType :: [T.Text] -> Maybe FilmType
  parseFilmType ["16mm film"] = Just F16mm
  parseFilmType ["35mm film"] = Just F35mm
  parseFilmType _             = Nothing

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
                 (scrapeURLWithConfig utf8Config moviesURL movies)
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
