
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

  addin = "Compare with..."
  file_1 <- normalizePath(get_active_file(addin))
  file_2 <- normalizePath(
    select_file(path = ".", filter = "*.*", addin)
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

  addin = "Compare with neighbor..."
  file_1 <- normalizePath(get_active_file(addin))
  file_2 <- normalizePath(
    select_file(path = dirname(file_1), filter = "*.*", addin)
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

  addin = "Compare with repo"
  file <- normalizePath(get_active_file(addin))

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
  stop_if_null(project_dir, "No active RStudio project detected.")

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
  ret <- system2("meld", args = c(file_1, file_2), wait = FALSE)
  invisible(ret)
}

# Returns active file path, triggers error message if null
get_active_file <- function (addin) {
  file <- rstudioapi::getSourceEditorContext()$path
  stop_if_null(file, paste(addin, "requires an active file (open and selected in the editor)."))
}

# Returns comparison file path, triggers error message if null
select_file <- function(path, addin, ...) {
  file <- rstudioapi::selectFile(path, ...)
  stop_if_null(file, addin_msg(addin, "requires a second file to compare."))
}

# Generates error message
addin_msg <- function(addin, msg) {
  sprintf("'%s' %s", addin, msg)
}

# Stops function if input is null
stop_if_null <- function(x, msg) {
  if (is.null(x)) {
    stop(msg, call. = FALSE)
  }
  invisible(x)
}
