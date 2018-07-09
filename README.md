<!-- README.md is generated from README.Rmd. Please edit that file -->
**compareWith**: RStudio addin with VCS capabilities
====================================================

Installation
------------

#### Prerequisite:

In order to access *private repositories* on Github programmatically, the best way is to generate a personal access token (PAT) online <https://github.com/settings/tokens>. Once generated, you need to copy the value and save it somewhere. Once you move away from the page, you will not be able to retrieve the value online anymore. To make the PAT available to R and RStudio sessions, the preferred option is to set the `GITHUB_PAT` environment variable in your `.Renviron` (e.g. under /etc/R on a typical Linux setup) to the value stored above. The package `devtools` will look for this environment variable.

#### You can then install **compareWith** from GitHub via:

``` r
devtools::install_github(
  "miraisolutions/miscellaneous/compareWith"
)
```
