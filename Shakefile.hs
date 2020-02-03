{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wcompat #-}
{-# OPTIONS_GHC -Wincomplete-record-updates #-}
{-# OPTIONS_GHC -Wincomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wredundant-constraints #-}

import           Development.Shake
import           Development.Shake.Command
import           Development.Shake.FilePath
import           Development.Shake.Util

css :: String
css = "http://www.columbia.edu/~akm2203/pandoc.css"

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles = "_build" } $ do
  want (fmap ("public_html" </>) ["index.html"])

  "//*.html" %> \out -> do
    let s = out -<.> "org"
    need [s]
    cmd_ "pandoc"
         ["-s", "-o", out, "-c", css, "--from", "org", "--to", "html5", s]

  phony "clean" $ do
    liftIO $ putStrLn "Cleaning files in _build"
    removeFilesAfter "_build" ["//*"]
