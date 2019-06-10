
#' Comparison addins
#'
#' RStudio [addins](https://rstudio.github.io/rstudioaddins/) for comparing
#' active files or projects against local or version control repository items.
#'
#' @eval section_addins()
#'
#' @seealso Function [compare_with()] for the flexible comparison of files.
#'
#' @name compareWith-addins
NULL


# addin binding
addin_other <- function() {

  addin <- "Compare with other..."
  compare_with(caller = addin)
}


# addin binding
addin_repo <- function() {

  addin <- "Compare with repo"
  compare_with(path = NA, caller = addin)
}


# addin binding
addin_project <- function() {

  addin <- "Compare with repo - project"
  project_dir <- rstudioapi::getActiveProject()
  stop_if_null(project_dir, info_msg(addin, "requires an active RStudio project."))

  compare_meld(project_dir)
}


#' File comparison
#'
#' Compare (active) `file` to a another selected by the user or to the version
#' control repository.
#'
#' @param file Optional path to an existing file to be compared. If `NULL` (the
#'   default), the active RStudio file is used.
#' @param path Path of the initial directory for selecting the second file to
#'   compare against via [selectFile()]. If `NULL` (the default), the directory
#'   of the first `file` is used. Use `NA` to compare a `file` under version
#'   control for with the repository version.
#' @param caller String information about the caller, to customize error
#'   messages.
#'
#' @template return-meld
#'
#' @seealso [RStudio addins][compareWith-addins] for file and project comparison
#'   with support for version control.
#'
#' @examples
#' \dontrun{
#' # compare active file, select second file from the same directory
#' compare_with()
#' # compare active file, select second file from the working directory
#' compare_with(path = getwd())
#' # compare active file, select second file from the home directory
#' compare_with(path = "~")
#' # compare a given file, select second file from the working directory
#' compare_with(file = "~/file1.ext", path = getwd())
#' # compare a given file under version control with the repository version
#' compare_with(file = "~/file1.ext", path = NA)
#' # custom caller information upon error, e.g. from a wrapper function
#' compare_home_dir <- function(file) {
#'   compare_with(file, path = "~", caller = "compare_home_dir")
#' }
#' my_wrapper("non/existing/file") # customized error message
#' }
#'
#' @export
compare_with <- function(file = NULL, path = NULL, caller = NULL) {

  if (is.null(caller)) {
    # error messages customized for function "compare_with"
    caller <- "compare_with"
  }
  if (is.null(file)) {
    file <- get_active_file(caller)
  }
  if (!file.exists(file)) {
    stop(info_msg(caller, "requires the path to an existing file"))
  }
  with <- if (!is.na(path)) { # NULL otherwise
    if (is.null(path)) {
      path <- dirname(file)
    }
    if (!dir.exists(path)) {
      stop(info_msg(caller, "requires an existing path for selecting the second file"))
    }
    select_file(path = path, caller)
  }

  compare_meld(file, with)
}


# Calls Meld, consider exposing this with full `meld` capability covering 3-way
# comparison, see `meld --help`
compare_meld <- function(file_1, file_2 = NULL) {
  ret <- system2("meld", args = c(shPath(file_1), shPath(file_2)), wait = FALSE)
  invisible(ret)
}

# Creates quoted path in canonical form for OS shell usage
shPath <- function(path) {
  if (!is.null(path)) {
    shQuote(normalizePath(path, mustWork = TRUE))
  }
}

# Returns active file path, trigger an error message if null
get_active_file <- function(caller) {
  file <- rstudioapi::getSourceEditorContext()$path
  stop_if_null(file, info_msg(caller, "requires an active file (open and selected in the editor)."))
}

# Returns comparison file path, trigger an error message if null
select_file <- function(path, caller, ...) {
  file <- rstudioapi::selectFile(path = path, ...)
  stop_if_null(file, info_msg(caller, "requires a second file to compare."))
}

# Constructs error message
info_msg <- function(what, msg) {
  sprintf("'%s' %s", what, msg)
}

# Checks if input is null and stop with a message
stop_if_null <- function(x, msg) {
  if (is.null(x)) {
    stop(msg, call. = FALSE)
  }
  invisible(x)
}
