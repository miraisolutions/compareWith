#' Version-control comparison of files
#'
#' @return Invisibly returns the result of the meld command.
#' @export
#'
#' @examples
#' \dontrun{compare_with()}
compare_with <- function() {
  file_1 <- normalizePath(
    rstudioapi::getSourceEditorContext()$path
  )
  file_2 <- normalizePath(
    rstudioapi::selectFile(path = ".", filter = "*.*")
  )
  ret <- system2("meld", args = c(file_1, file_2), wait = FALSE)
  invisible(ret)
}
