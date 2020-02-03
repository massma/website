{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wcompat #-}
{-# OPTIONS_GHC -Wincomplete-record-updates #-}
{-# OPTIONS_GHC -Wincomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wredundant-constraints #-}

import           Development.Shake
import           Development.Shake.Command
import           Development.Shake.FilePath
import           Development.Shake.Util

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles = "_build" } $ do
  phony "clean" $ do
    liftIO $ putStrLn "Cleaning files in _build"
    removeFilesAfter "_build" ["//*"]
