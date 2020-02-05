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

addHeader :: String -> String
addHeader contents = unlines (header <> default' <> rest)
 where
  p xs = case xs of
    (x1 : x2 : _xs) -> [x1, x2] == "#+"
    _               -> False
  (header, rest) = span p (lines contents)
  default' =
    [ "#+AUTHOR: Adam Massmann"
    , "#+EMAIL: akm2203 \"at\" columbia \"dot\" edu"
    , "#+LANGUAGE: en"
    , "[[file:index.html][{Back to Home}]]"
    ]

htmlToSrc :: FilePath -> FilePath
htmlToSrc h = "dat" </> takeFileName h -<.> "org"

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles = "_build" } $ do
  want
    (fmap
      ("public_html" </>)
      ["index.html", "masters-research.html", "vpd-et.html", "writing.html"]
    )

  "//*.html" %> \out -> do
    let s      = htmlToSrc out
    let parser = if takeFileName out == "index.html" then id else addHeader
    need [s]
    contents <- liftIO (parser <$> readFile s)
    cmd_ (Stdin contents)
         "pandoc"
         ["-s", "-o", out, "-c", css, "--from", "org", "--to", "html5"]

  phony "clean" $ do
    liftIO $ putStrLn "Cleaning files in _build"
    removeFilesAfter "_build" ["//*"]
