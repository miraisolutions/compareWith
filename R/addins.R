#' Comparison addins
#'
#' RStudio [addins](https://rstudio.github.io/rstudioaddins/) for comparing
#' active files or projects against local or version control repository items.
#'
#' @eval man_section_addins()
#'
#' @seealso Functions [compare_with_other()] and [compare_with_repo()] for the
#'   flexible comparison of files and directories.
#'
#' @name compareWith-addins
NULL

# Addin bindings (not exported), with addin-specific errors

addin_other <- function() {
  with_addin_errors(
    addin = "Compare with other...",
    compare_active_file_with_other()
  )
}

addin_repo <- function() {
  with_addin_errors(
    addin = "Compare with repo",
    compare_active_file_with_repo()
  )
}

addin_project <- function() {
  with_addin_errors(
    addin = "Compare with repo - project",
    compare_project_with_repo()
  )
}

# Handle addin-specific error messages
addin_message <- function(addin, condition) {
  sprintf("'%s' - %s", addin, condition$message)
}
with_addin_errors <- function(expr, addin) {
  withCallingHandlers(
    expr,
    error = function(e) {
      stop(addin_message(addin, e), call. = FALSE)
    }
  )
}
# with_addin_errors(stop("Not good"), "My Addin")
