
#' Version-control comparison of files
#'
#' @rdname compare_with
#'
#' @description Compare active file with other file (search working directory).
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

  addin <- "Compare with..."
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
#' @description Compare active file with other file (search same directory).
#'
#' @export
#'
#' @examples
#' \dontrun{compare_with_neighbor()}
compare_with_neighbor <- function() {

  addin <- "Compare with neighbor..."
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
#' @description Compare active file with version control repository.
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

  addin <- "Compare with repo"
  file <- normalizePath(get_active_file(addin))

  compare_meld(file)
}


#' Compare with repo (project)
#'
#' @rdname compare_project_with_repo
#'
#' @description Compare active project with version control repository.
#'
#' @export
#'
#' @examples
#' \dontrun{compare_project_with_repo()}
compare_project_with_repo <- function() {

  addin <- "Compare with repo (project)"
  project_dir <- rstudioapi::getActiveProject()
  stop_if_null(project_dir, addin_msg(addin, "requires an active RStudio project."))

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

# Return active file path, trigger an error message if null
get_active_file <- function(addin) {
  file <- rstudioapi::getSourceEditorContext()$path
  stop_if_null(file, paste(addin, "requires an active file (open and selected in the editor)."))
}

# Return comparison file path, trigger an error message if null
select_file <- function(path, addin, ...) {
  file <- rstudioapi::selectFile(path = path, ...)
  stop_if_null(file, addin_msg(addin, "requires a second file to compare."))
}

# Construct error message
addin_msg <- function(addin, msg) {
  sprintf("'%s' %s", addin, msg)
}

# Check if input is null and stop with a message
stop_if_null <- function(x, msg) {
  if (is.null(x)) {
    stop(msg, call. = FALSE)
  }
  invisible(x)
}
