#' Version-control comparison of files
#'
#' @rdname compare_with
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


#' Compare with neighbor
#'
#' @rdname compare_with_neighbor
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


#' Compare with repo
#'
#' @rdname compare_with_repo
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


#' Compare with repo (project)
#'
#' @rdname compare_project_with_repo
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

#' Compare meld
#'
#' @rdname compare_meld
#'
#' @param file_1 First file to compare.
#' @param file_2 Second file to compare.
#'
#' @examples
#' \dontrun{compare_meld()}
compare_meld <- function(file_1, file_2 = NULL) {
  return_version()
  ret <- system2("meld", args = c(file_1, file_2), stdout = TRUE, wait = FALSE)
  invisible(ret)
}

# Returns meld version or warning message if meld is not installed
return_version <- function() {
  w <- 0
  withCallingHandlers(
    system2("meld", "--version"),
    warning = function(x) {
      w <<- 1
      invokeRestart("muffleWarning")
    }
  )

  if(w == 1) {
    stop("Meld is not installed on this computer. Please follow instructions on README.", call. = FALSE)
  } else {
    system2("meld", "--version")
  }
}
