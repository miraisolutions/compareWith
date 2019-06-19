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

# Addin bindings (not exported), with addin-specific errors. An attribute with
# the addin name is also added, and used for unit-testing the consistency with
# addins.dcf.
addin_factory <- function(addin, body) {
  # get the body as expression from the call
  body <- match.call()$body
  # alternative implementations
  # 1. evaluate the expression inside the binding function (lexical scoping)
  binding.1 <- function() {
    with_addin_errors(eval(body), addin)
  }
  # 2. use substitute to get the body of the addin binding same as if manually
  # created, and use it to construct the binding function
  # > 2.1. by using function as a function
  # > > 2.1.1
  binding.2.1.1 <- eval(call("function", NULL, substitute(
    with_addin_errors(body, addin))
  ))
  # > > 2.1.2
  binding.2.1.2 <- do.call("function", list(NULL, substitute(
    with_addin_errors(body, addin))
  ))
  # > 2.2. by re-assigning the body
  binding.2.2 <- function() {}
  body(binding.2.2) <- substitute(
    with_addin_errors(body, addin)
  )
  binding <- binding.2.1.1
  attr(binding, "addin") <- addin
  binding
}
addin_other <- addin_factory(
  addin = "Compare with other...",
  compare_active_file_with_other()
)
addin_repo <- addin_factory(
  addin = "Compare with repo",
  compare_active_file_with_repo()
)
addin_project <- addin_factory(
  addin = "Compare with repo - project",
  compare_project_with_repo()
)

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
