<!-- README.md is generated from README.Rmd. Please edit that file -->
**compareWith**: RStudio addin with VCS capabilities
====================================================

compareWith provides user-friendly addins that enable and improve tasks that are otherwise difficult or impossible without any custom extension. Examples include: 

  - compare differences prior to commit, for single active files or the whole project; 
  - resolve and merge conflicts via three-way comparison; 
  - compare 2 distinct files with each other.

Installation
------------

You can install **compareWith** from GitHub using the `remotes` package:

``` r
remotes::install_github(
  "miraisolutions/compareWith"
)
```

An installation of [`meld`](http://meldmerge.org) is also required, which can be done for Linux with `sudo apt-get install meld`.

On Windows, the installation is supported by the official website. It only requires to add `meld.exe` to the `PATH` environment variable.

MacOS is currently not supported. It is advisable to use the precompiled binaries from the website; however, this installation does not allow to call `meld` from the command line. You can either update your `.bashrc` file or install `meld` via `homebrew`:

      brew tap homebrew/cask
      brew cask install meld
