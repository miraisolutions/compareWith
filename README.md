<!-- README.md is generated from README.Rmd. Please edit that file -->
**compareWith**: RStudio addin with VCS capabilities
====================================================

Installation
------------

#### Prerequisite:

In order to access *private repositories* on Github programmatically, the best way is to generate a personal access token (PAT) online <https://github.com/settings/tokens>.  
You can give it an arbitrary description, e.g. `Install private Github repos with devtools from RStudio Linux`. In the section **Select scopes**, tick **repo** (it's the first one). Then click the button to generate your token.

Once generated, you need to copy the value and save it somewhere. Once you move away from the page, you will not be able to retrieve the value online anymore. To make the PAT available to R and RStudio sessions, the preferred option is to set the `GITHUB_PAT` environment variable in your `.Renviron` file (e.g. under `/etc/R` on a typical Linux setup) to the value stored above. The package `devtools` will look for this environment variable.

An installation of `meld` is also required. You can install it for Linux as `sudo apt get install meld`. MacOS, is not yet supported. It is suggested to use the precompiled binaries from he [meld website](http://meldmerge.org); however, this installation does not allow to call `meld` form command line. You can either update your `.bashrc` file or install `meld` via `homebrew`.

```
brew tap homebrew/cask
brew cask install meld
```

#### You can then install **compareWith** from GitHub via:

``` r
devtools::install_github(
  "miraisolutions/miscellaneous/compareWith"
)
```

