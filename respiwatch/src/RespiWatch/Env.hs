{-# LANGUAGE NoImplicitPrelude #-}
module RespiWatch.Env where

import           RespiWatch.Options             ( Options )
import           RIO

data Paths = Paths
  { pRShieldURL :: !Text
  }

data Env = Env
  { envLogFunc :: !LogFunc
  , envOptions :: !Options
  , envPaths   :: !Paths
  }

class HasOptions env where
  optionsL :: Lens' env Options

class HasPaths env where
  pathsL :: Lens' env Paths

instance HasLogFunc Env where
  logFuncL = lens envLogFunc (\x y -> x { envLogFunc = y })

instance HasOptions Env where
  optionsL = lens envOptions (\x y -> x { envOptions = y })


instance HasPaths Env where
  pathsL = lens envPaths (\x y -> x { envPaths = y })
