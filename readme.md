Source for my website, built with pandoc, managed by Shake.

All written content on the website is licensed under a [Creative Commons
Attribution 4.0 International
License](https://creativecommons.org/licenses/by/4.0/). Source code is
licensed under either the BSD-3-clause or the Apache-2.0 license; see
[LICENSE.org](LICENSE.org)

Required software
=================

-   [pandoc](https://pandoc.org/)
-   [The Haskell GHC Compiler and Cabal Build
    tool](https://www.haskell.org/downloads/#minimal)
-   [texlive](https://www.tug.org/texlive/)
-   [emacs](https://www.gnu.org/software/emacs/)
-   [Graphviz](https://graphviz.org/)

Build instructions
==================

Windows (untested)
------------------

Clone this repository, enter directory, and run:

``` {.bash}
cabal build && cabal run build
```

GNU/Linux instructions
----------------------

Clone this repository, enter directory, and run:

``` {.bash}
cabal build && cabal run build
```

or, with GNU Make:

``` {.bash}
make
```

This should also probably work on OSX, but I haven\'t tested it.
