#' File and directory comparison
#'
#' Compare file or directory to another selected by the user or to the version
#' control repository.
#'
#' @param path Path to an existing file or directory to be compared.
#' @param location Initial path for selecting the other file or directory (via
#'   [selectFile()] or [selectDirectory()])to compare against. If `NULL` (the
#'   default), the parent directory of the input `path` is used.
#'
#' @template return-meld
#'
#' @seealso [RStudio addins][compareWith-addins] for file and project comparison
#'   with support for version control.
#'
#' @example man-roxygen/ex-compare_with.R
#'
#' @name compare_with
NULL


#' @eval man_describeIn_compare_with("path", "other")
#'
#' @export
compare_with_other <- function(path = NULL, location = NULL) {

  # make sure `path` exists
  check_path(path)
  # is `path` a directory?
  is_dir <- dir.exists(path)
  # default `location`: same parent directory as `path`
  if (is.null(location)) {
    location <- dirname(path)
  } else {
    # make sure `location` exists
    check_path(location, what = "location")
  }
  # select using the appropriate selection dialog
  other <- select_other(location, is_dir)

  # compare
  compare_meld(path, other)
}


#' @eval man_describeIn_compare_with("path", "repo")
#'
#' @export
compare_with_repo <- function(path) {

  # make sure `path` exists
  check_path(path)

  compare_meld(path)
}


#' @eval man_describeIn_compare_with("active_file", "other")
#'
#' @export
compare_active_file_with_other <- function(location = NULL) {
  compare_with_other(get_active_file(), location)
}


#' @eval man_describeIn_compare_with("active_file", "repo")
#'
#' @export
compare_active_file_with_repo <- function() {
  compare_with_repo(get_active_file())
}


#' @eval man_describeIn_compare_with("active_project", "repo")
#'
#' @export
compare_project_with_repo <- function() {
  compare_with_repo(get_active_project())
}


# Checks that `path` exists with custom error message
check_path <- function(path, what = "path") {
  if (!file.exists(path)) {
    stop("The provided ", what, " ", sQuote(path), " does not exist.")
  }
  invisible(path)
}


# Returns path of active file, triggers an error message if null
get_active_file <- function() {
  file <- rstudioapi::getSourceEditorContext()$path
  stop_if_null(file, "An active file (open and selected in the editor) is required.")
}


# Returns path of active project, triggers an error message if null
get_active_project <- function() {
  project_dir <- rstudioapi::getActiveProject()
  stop_if_null(project_dir, "An active RStudio project is required.")
}


# Constructs the title for the select dialog window
dialog_caption <- function(is.dir = FALSE) {
  what <- if (is.dir) "directory" else "file"
  sprintf("Select a %s to compare against", what)
}


# Returns comparison file/directory path, triggers an error message if null
select_other <- function(location, is.dir = FALSE) {
  # use the appropriate selection dialog
  selectOther <- if (is.dir) {
    rstudioapi::selectDirectory
  } else {
    rstudioapi::selectFile
  }
  caption <- dialog_caption(is.dir)
  other <- selectOther(path = location, caption = caption)
  stop_if_null(other, paste0("You must ", tolower(caption), "."))
}


# Checks if input is null and stop with a message
stop_if_null <- function(x, msg) {
  if (is.null(x)) {
    stop(msg, call. = FALSE)
  }
  invisible(x)
}


# Calls Meld, consider exposing this with full `meld` capability covering 3-way
# comparison, see `meld --help`
compare_meld <- function(file_1, file_2 = NULL) {
  ret <- sys::exec_background(
    "meld", args = normalizePath(c(file_1, file_2)),
    std_out = TRUE, std_err = TRUE
  )
  invisible(ret)
}
