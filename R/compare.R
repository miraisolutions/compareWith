#' Version-control comparison of files
#'
#' Compares active file with another (search working directory). Functions are called using Addins.
#'
#' @return Invisibly returns the result of the meld command.
#'
#' @describeIn compare_with compares active file with another (search working directory).
#' @template addin-name 'compare with...'.
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


#' @describeIn compare_with compares active file with another within
#' the same directory. @template addin-name 'compare with neighbor...'.
#'
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


#' @describeIn compare_with compares the current file and RStudio project with
#' the version control repository version. @template addin-name 'compare with repo'.
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


#' @describeIn compare_with compares the current file and RStudio
#' project with the version control repository version. @template addin-name
#' 'compare with repo (project)'.
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


#' @describeIn compare_with calls meld.
#'
#' @param file_1 First file to compare.
#' @param file_2 Second file to compare.
#'
#' @examples
#' \dontrun{compare_meld()}
compare_meld <- function(file_1, file_2 = NULL) {
  ret <- system2("meld", args = c(file_1, file_2), wait = FALSE)
  invisible(ret)
}
