{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wcompat #-}
{-# OPTIONS_GHC -Wincomplete-record-updates #-}
{-# OPTIONS_GHC -Wincomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wredundant-constraints #-}

import qualified Data.Maybe as M
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util
import qualified Text.ParserCombinators.ReadP as RP

css :: String
css = "http://www.columbia.edu/~akm2203/pandoc.css"

type Document = [Item]

data Item = Yaml String | Rest String deriving (Show)

yamlStart :: String
yamlStart = "---\n"

yamlEnd :: String
yamlEnd = "\n---\n"

showDocument :: Document -> String
showDocument = foldMap go
  where
    go (Yaml x) = yamlStart <> x <> yamlEnd
    go (Rest x) = x

parseDocument :: RP.ReadP Document
parseDocument = do
  xs <-
    (parseYaml >>= (\y -> parseRest >>= (\r -> return [y, r])))
      RP.<++ ((: []) <$> parseRest)
  _ <- RP.eof
  return xs

parseYaml :: RP.ReadP Item
parseYaml = do
  _ <- RP.string yamlStart
  ymls <- RP.many RP.get
  _ <- RP.string yamlEnd
  return (Yaml ymls)

parseRest :: RP.ReadP Item
parseRest = Rest <$> RP.munch1 (const True)

prependStr :: String -> Document -> Document
prependStr x (y@(Yaml _) : rest) = (y : Rest x : rest)
prependStr x xs = Rest x : xs

maybeParse :: RP.ReadP a -> String -> Maybe a
maybeParse p s = case RP.readP_to_S p s of
  (x, "") : [] -> Just x
  (_x, _xs) : _ -> Nothing
  [] -> Nothing

-- | converts a filepath for an output file (e.g. html) in
-- @public_html@ to its corresponding source in @website-src@
htmlToSrc :: FilePath -> FilePath
htmlToSrc pul = case splitDirectories pul of
  (x : xs) ->
    if x == "public_html"
      then foldl (</>) "website-src" xs
      else error "called htmlToSrc on a file not in publc_html"
  _ -> pul

cvStyle = (</> "mycv.sty")

replaceAll ::
  -- | String to search for
  String ->
  -- | String to repalce
  String ->
  -- | string to search
  String ->
  String
replaceAll s r xs = go xs
  where
    l = length s
    go ys = case splitAt l ys of
      (h, rest)
        | h == s -> r <> go rest
        | null rest -> h
        | otherwise -> (head h) : (go (drop 1 ys))

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
    need
      ( fmap
          ("public_html" </>)
          [ "index.html",
            "masters-research.html",
            "vpd-et.html",
            "ccm.html",
            "writing.html",
            "eaee-ta-resources.html",
            "eaee-ta-resources-workshop-version.html",
            "climate-school.html",
            "cv" </> "massmann-cv.html",
            "cv" </> "massmann-cv.pdf"
          ]
      )

  "public_html/*.html" %> \out -> do
    let s = htmlToSrc out -<.> "md"
    let parser =
          if takeFileName out == "index.html"
            then id
            else
              showDocument
                . prependStr "\n[{Back to Home}](index.html)\n"
                . M.fromMaybe (error ("failed to parse yaml: " <> s))
                . maybeParse parseDocument
    need [s, "Shakefile.hs"]
    contents <- liftIO (parser . replaceAll ".md" ".html" <$> readFile s)
    cmd_
      (Stdin contents)
      "pandoc"
      ["-s", "-o", out, "-c", css, "--from", "markdown", "--to", "html5"]

  "public_html/cv/*" %> \out -> do
    let s = htmlToSrc out
    need [s]
    cmd_ "cp" [s, out]

  "website-src/cv/*.html" %> \out -> do
    let s = out -<.> "org"
    need [s, (cvStyle . takeDirectory $ out), "Shakefile.hs"]
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

  "website-src/cv/*.pdf" %> \out -> do
    let s = out -<.> "org"
    need [s, (cvStyle . takeDirectory $ out), "Shakefile.hs"]
    cmd_
      (Cwd (takeDirectory out))
      Shell
      "emacs"
      [takeFileName s, "--batch", "-f", "org-latex-export-to-pdf", "--kill"]

  phony "clean" $ do
    liftIO $ putStrLn "Cleaning files in _build"
    removeFilesAfter "_build" ["//*"]
