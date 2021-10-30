{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}

module Main (main) where

import Macroscope.Main (runMacroscope)
import Monocle.Client (withClient)
import Options.Generic
import Relude

data Macroscope w = Macroscope
  { monocleUrl :: w ::: Maybe Text <?> "The monocle API",
    config :: w ::: Maybe FilePath <?> "The monocle configuration",
    debug :: w ::: Bool <?> "Verbose mode",
    interval :: w ::: Maybe Word32 <?> "Interval in seconds, default to 600",
    port :: w ::: Int <!> "9001" <?> "Health check port"
  }
  deriving stock (Generic)

instance ParseRecord (Macroscope Wrapped) where
  parseRecord = parseRecordWithModifiers lispCaseModifiers

main :: IO ()
main = do
  args <- unwrapRecord "Macroscope lentille runner"
  config' <- fromMaybe (error "--config or CONFIG env is required") <$> lookupEnv "CONFIG"
  withClient (fromMaybe "http://web:8080" $ monocleUrl args) Nothing $ \client ->
    runMacroscope
      (port args)
      (debug args)
      (fromMaybe config' $ config args)
      (fromMaybe 600 (interval args))
      client
