
.onLoad <- function(libname, pkgname) {
  # In principle we should not be messaging anything .onLoad(), not even via
  # packageStartupMessage (NOTE in R CMD CHECK)
  packageStartupMessage("Check Meld installation:")
  packageStartupMessage(check_meld_version())
}

check_readme_msg <- c(
  "Check instructions in the package README\n",
  "<https://github.com/miraisolutions/compareWith#installation>."
)

# Check (and return) Meld version, stop if Meld is not installed or there are
# issues determining its version. Extra arguments allow mimicking error
# situations for testing
check_meld_version <- function(meld = "meld", option = "--version") {
  out <- withCallingHandlers(
    suppressWarnings(system2(meld, option, stdout = TRUE)),
    error = function(e) {
      stop(
        "Unable to detect a Meld installation.\n",
        "Make sure `meld` is installed and can be called from the command line.\n",
        check_readme_msg,
        call. = FALSE
      )
    }
  )
  if (isTRUE(attr(out, "status") != 0)) {
    message(paste(out, collapse = "\n"))
    stop(
      "Existing Meld installation not working correctly.\n",
      "Make sure you have a fully functional `meld` installed in your system.\n",
      check_readme_msg,
      call. = FALSE
    )
  }
  # return the successful result of meld --version
  out
}
