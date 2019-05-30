check_readme_msg <- c(
  "Check instructions in the package README\n",
  "<https://github.com/miraisolutions/compareWith#installation>."
)

.onLoad <- function(libname, pkgname) {
  # Check Meld version, stop pkg loading if Meld is not installed or there are
  # issues determining its version
  cat("Check Meld installation:\n")
  suppressWarnings({
    status <- system2("meld", "--version")
    if (status == 127) {
      stop(
        "Unable to detect a Meld installation.\n",
        "Make sure `meld` is installed and can be called from the command line.\n",
        check_readme_msg,
        call. = FALSE
      )
    } else if (status != 0) {
      stop(
        "Existing Meld installation not working correctly.\n",
        "Make sure you have a fully functional `meld` installed in your system.\n",
        check_readme_msg,
        call. = FALSE
      )
    }
  })
}
