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


#' @rdname compare_with
#' @details compare_with_neighbor starts the file search in the directory of the
#' first file, while compare_with starts the file search in the project root
#' directory
#' @export
#'
#' @examples
#' \dontrun{compare_with_neighbor()}
compare_with_neighbor <- function() {
  file_1 <- normalizePath(
    rstudioapi::getSourceEditorContext()$path
  )
  file_2 <- normalizePath(
    rstudioapi::selectFile(path = dirname(file_1), filter = "*.*")
  )
  ret <- system2("meld", args = c(file_1, file_2), wait = FALSE)
  invisible(ret)
}
