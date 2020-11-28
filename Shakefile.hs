{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wcompat #-}
{-# OPTIONS_GHC -Wincomplete-record-updates #-}
{-# OPTIONS_GHC -Wincomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wredundant-constraints #-}

import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

css :: String
css = "http://www.columbia.edu/~akm2203/pandoc.css"

-- | parses the content of a .org file and adds a link to the home
-- page and some meta data
addHeader :: String -> String
addHeader contents = unlines (header <> default' <> rest)
  where
    p xs = case xs of
      (x1 : x2 : _xs) -> [x1, x2] == "#+"
      _ -> False
    (header, rest) = span p (lines contents)
    default' =
      [ "#+AUTHOR: Adam Massmann",
        "#+EMAIL: akm2203 \"at\" columbia \"dot\" edu",
        "#+LANGUAGE: en",
        "\n[[file:index.html][{Back to Home}]]"
      ]

-- | converts a filepath for an output file (e.g. html) in
-- @public_html@ to its corresponding source in @dat@
publicToDat :: FilePath -> FilePath
publicToDat pul = case splitDirectories pul of
  (x : xs) ->
    if x == "public_html"
      then foldl (</>) "dat" xs
      else error "called publicToDat on a file not in publc_html"
  _ -> pul

cvStyle = (</> "mycv.sty")

main :: IO ()
main = shakeArgs shakeOptions {shakeFiles = "_build"} $ do
  action $ do
    cmd_ (Cwd "extras/teacher-learner-wellbeing") "make"
    cmd_
      "cp"
      Shell
      [ "-r",
        "-u",
        "extras"
          </> "teacher-learner-wellbeing"
          </> "public_html"
          </> "*",
        "public_html" </> "teacher-learner-wellbeing/"
      ]
    putInfo "test"
    need
      ( fmap
          ("public_html" </>)
          [ "index.html",
            "masters-research.html",
            "vpd-et.html",
            "writing.html",
            "eaee-ta-resources.html",
            "eaee-ta-resources-workshop-version.html",
            "climate-school.html",
            "cv" </> "massmann-cv.html",
            "cv" </> "massmann-cv.pdf",
            "cv" </> "massmann-cv-short.pdf"
          ]
      )

  "public_html/*.html" %> \out -> do
    let s = publicToDat out -<.> "org"
    let parser = if takeFileName out == "index.html" then id else addHeader
    need [s]
    contents <- liftIO (parser <$> readFile s)
    cmd_
      (Stdin contents)
      "pandoc"
      ["-s", "-o", out, "-c", css, "--from", "org", "--to", "html5"]

  "public_html/cv/*" %> \out -> do
    let s = publicToDat out
    need [s]
    cmd_ "cp" [s, out]

  "dat/cv/*.html" %> \out -> do
    let s = out -<.> "org"
    need [s, (cvStyle . takeDirectory $ out)]
    cmd_
      (Cwd (takeDirectory out))
      Shell
      "emacs"
      [ takeFileName s,
        "--batch",
        "--eval",
        "\"(progn (setq org-export-with-section-numbers nil) (setq org-html-validation-link nil))\"",
        "-f",
        "org-html-export-to-html",
        "--kill"
      ]

  "dat/cv/*.pdf" %> \out -> do
    let s = out -<.> "org"
    need [s, (cvStyle . takeDirectory $ out)]
    cmd_
      (Cwd (takeDirectory out))
      Shell
      "emacs"
      [takeFileName s, "--batch", "-f", "org-latex-export-to-pdf", "--kill"]

  phony "clean" $ do
    liftIO $ putStrLn "Cleaning files in _build"
    removeFilesAfter "_build" ["//*"]
