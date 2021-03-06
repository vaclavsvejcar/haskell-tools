module Mat35.URLs
  ( moviesURL
  , rootURL
  )
where


-- | URL to fetch all 35mm movies.
moviesURL :: String
moviesURL = rootURL ++ "/kino/cz/cykly?action=projekce-z-filmoveho-pasu"

-- | Root URL of the MAT Cinema website.
rootURL :: String
rootURL = "http://www.mat.cz"
