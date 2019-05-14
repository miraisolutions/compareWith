
#' Version-control comparison of files
#'
#' Compare active files or projects against local or version control repository
#' items. Functions are called by the \pkg{compareWith} addins.
#'
#' @return Invisibly returns the result of calling the `meld` command via
#'   [system2()].
#'
#' @templateVar desc compares active file with another (search working directory).
#' @templateVar addin Compare with...
#' @template describeIn-addin-func
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


#' @templateVar desc compares active file with another (search same directory).
#' @templateVar addin Compare with neighbor...
#' @template describeIn-addin-func
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


#' @templateVar desc compares active file with the version control repository.
#' @templateVar addin Compare with repo
#' @template describeIn-addin-func
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


#' @templateVar desc compares active RStudio project with the version control repository.
#' @templateVar addin Compare with repo (project)
#' @template describeIn-addin-func
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


# Calls Meld, consider exposing this with full `meld` capability covering 3-way
# comparison, see `meld --help`
compare_meld <- function(file_1, file_2 = NULL) {
  ret <- system2("meld", args = c(file_1, file_2), wait = FALSE)
  invisible(ret)
}

# Returns active file path, trigger an error message if null
get_active_file <- function(addin) {
  file <- rstudioapi::getSourceEditorContext()$path
  stop_if_null(file, paste(addin, "requires an active file (open and selected in the editor)."))
}

# Returns comparison file path, trigger an error message if null
select_file <- function(path, addin, ...) {
  file <- rstudioapi::selectFile(path = path, ...)
  stop_if_null(file, addin_msg(addin, "requires a second file to compare."))
}

# Constructs error message
addin_msg <- function(addin, msg) {
  sprintf("'%s' %s", addin, msg)
}

# Checks if input is null and stop with a message
stop_if_null <- function(x, msg) {
  if (is.null(x)) {
    stop(msg, call. = FALSE)
  }
  invisible(x)
}
