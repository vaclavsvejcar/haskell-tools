module Mat35.URLs where

-- | Root URL of the MAT Cinema website.
rootURL :: String
rootURL = "http://www.mat.cz"

-- | URL to fetch all 35mm screenings.
screeningsPageURL :: String
screeningsPageURL =
  rootURL ++ "/kino/cz/cykly?action=projekce-z-filmoveho-pasu"
