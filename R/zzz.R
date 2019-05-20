.onLoad <- function(libname, pkgname) {
# Stop loading of pkg if Meld is not installed or is encountering issues
  tryCatch({
    system2("meld", "--version")},
    warning = function(w) {
      stop("Meld is not installed or has some issues. Please follow instructions on README.",
           call. = FALSE)
    })

}
