
.onLoad <- function(libname, pkgname) {
  # In principle we should not be messaging anything .onLoad(), not even via
  # packageStartupMessage (NOTE in R CMD CHECK)
  packageStartupMessage("Checking Meld installation:")
  packageStartupMessage(check_meld_version())
}

check_readme_msg <- c(
  "Check instructions in the package README\n",
  "<https://github.com/miraisolutions/compareWith#installation>."
)

# Check (and return) Meld version, stop if Meld is not installed or there are
# issues determining its version. Extra arguments allow mimicking error
# situations for testing.
check_meld_version <- function(meld = "meld", option = "--version") {
  out <- withCallingHandlers(
    sys::exec_internal(meld, option, error = FALSE),
    error = function(e) {
      stop(
        "Unable to detect a Meld installation.\n",
        "Make sure `meld` is installed and can be called from the command line.\n",
        check_readme_msg,
        call. = FALSE
      )
    }
  )
  if (isTRUE(out$status != 0)) {
    warning(
      paste(sys::as_text(c(out$stdout, out$stderr)), collapse = "\n"),
      immediate. = TRUE, call. = FALSE
    )
    stop(
      "Existing Meld installation not working correctly.\n",
      "Make sure you have a fully functional `meld` installed in your system.\n",
      check_readme_msg,
      call. = FALSE
    )
  }
  sys::as_text(out$stdout)
}
