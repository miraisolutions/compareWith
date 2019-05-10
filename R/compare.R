
#' Version-control comparison of files
#'
#' Compares active file with another (search working directory). Functions are called using Addins.
#'
#' @return Invisibly returns the result of the meld command.
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


#' @templateVar desc compares active file with another within the same directory.
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


#' @templateVar desc compares the current file and RStudio project with the version control repository version.
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


#' @templateVar desc compares the current file and RStudio project with the version control repository version.
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
