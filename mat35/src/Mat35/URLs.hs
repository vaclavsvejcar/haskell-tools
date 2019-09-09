module Mat35.URLs where

-- Root URL of the MAT Cinema website.
rootURL :: String
rootURL = "http://www.mat.cz"

-- URL to fetch all 35mm screenings.
screeningsURL :: String
screeningsURL = rootURL ++ "/kino/cz/cykly?action=projekce-z-filmoveho-pasu"

-- URL to fetch ticket portal page for movie, specified by its ticket ID.
ticketsURL :: String -> String
ticketsURL id = "https://system.cinemaware.eu/wstep1.php?id=" ++ id

-- URL to fetch movie detail, specified by its movie ID.
movieURL :: String -> String
movieURL id = rootURL ++ "/kino/cz/kino-mat?movie-id=" ++ id
