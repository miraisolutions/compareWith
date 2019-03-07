<!-- README.md is generated from README.Rmd. Please edit that file -->
**compareWith**: RStudio addin with VCS capabilities
====================================================

Installation
------------

You can install **compareWith** from GitHub using the `remotes` package:

``` r
remotes::install_github(
  "miraisolutions/compareWith"
)
```

An installation of [`meld`](http://meldmerge.org) is also required. You can install it for Linux with `sudo apt-get install meld`.

On Windows, the installation is supported by the official website. You just need to be sure to add the path to `meld.exe` to the `PATH` environment variable.

MacOS is currently not supported. It is suggested to use the precompiled binaries from the website; however, this installation does not allow to call `meld` from the command line. You can either update your `.bashrc` file or install `meld` via `homebrew`:

    brew tap homebrew/cask
    brew cask install meld
