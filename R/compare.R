#' Version-control comparison of files
#'
#' @return Invisibly returns the result of the meld command.
#'
#' @details `compare_with_neighbor` starts the file search in the directory of
#'   the first file, while `compare_with` starts the file search in the working
#'   directory.
#'
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
  compare_meld(file_1, file_2)
}


#' @rdname compare_with
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
  compare_meld(file_1, file_2)
}


#' @rdname compare_with
#'
#' @details `compare_with_repo` and `compare_project_with_repo` compare the
#'   current file and RStudio project with the version control repository
#'   version.
#'
#' @export
#'
#' @examples
#' \dontrun{compare_with_repo()}
compare_with_repo <- function() {
  file <- normalizePath(
    rstudioapi::getSourceEditorContext()$path
  )
  compare_meld(file)
}


#' @rdname compare_with
#'
#' @export
#'
#' @examples
#' \dontrun{compare_project_with_repo()}
compare_project_with_repo <- function() {
  project_dir <- rstudioapi::getActiveProject()
  if (is.null(project_dir)) {
    stop("No active RStudio project detected.")
  }
  compare_meld(project_dir)
}


compare_meld <- function(file_1, file_2 = NULL) {
  ret <- system2("meld", args = c(file_1, file_2), wait = FALSE)
  invisible(ret)
}
