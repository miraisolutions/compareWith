.onLoad <- function(libname, pkgname) {
  # Stop loading of pkg if Meld is not installed or is encountering issues
  suppressWarnings({
    status <- system2("meld", "--version")
    if (status == 127) {
      stop("
           Meld is not installed or not added to the path environment variable.
           Check instructions on README
           (https://github.com/miraisolutions/compareWith#Installation).",
           call. = FALSE)
    } else if (status > 0 && status != 127) {
      stop("
           Existing Meld is not working correctly.
           Make sure your Meld installation is fully functional. Check instructions on README
           (https://github.com/miraisolutions/compareWith#Installation).",
           call. = FALSE)
    }
  })
}
