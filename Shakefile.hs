{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wcompat #-}
{-# OPTIONS_GHC -Wincomplete-record-updates #-}
{-# OPTIONS_GHC -Wincomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wredundant-constraints #-}

import           Development.Shake
import           Development.Shake.Command
import           Development.Shake.FilePath
import           Development.Shake.Util

css :: FilePath
css = "pandoc.css"

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles = "_build" } $ do
  want (fmap ("public_html" </>) ["index.html"])

  "//*.html" %> \out -> do
    let s = out -<.> "md"
    need [s, "pandoc.css"]
    cmd_ "pandoc"
         ["-o", out, "-c", css, "--from", "markdown", "--to", "html5", s]

  "//*.md" %> \out -> do
    let s = out -<.> "org"
    need [s]
    cmd_ "pandoc" ["-o", out, "--from", "org", "--to", "markdown", s]

  phony "clean" $ do
    liftIO $ putStrLn "Cleaning files in _build"
    removeFilesAfter "_build" ["//*"]
