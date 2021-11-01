# Create a documentation section 'Addins' with name and description dynamically
# extracted from addins.dcf
man_section_addins <- function() {
  addins <- read.dcf(system.file("rstudio/addins.dcf", package = "compareWith"))
  c(
    "@section Addins:",
    "\\describe{",
    sprintf("\\item{**%s**}{%s.}", addins[, "Name"], addins[, "Description"]),
    "}"
  )
}


# Construct a description for any of the compare_with functions
describe_compare_with <- function(what, with) {
  what <- switch(
    what,
    path = "a file or directory",
    active_file = "the active file",
    active_project = "the active project"
  )
  with <- switch(
    with,
    other = "another selected by the user",
    repo = "the version control repository"
  )
  paste("Compares", what, "against", with)
}


# Create a @describeIn tag for any compare_with function
man_describeIn_compare_with <- function(what, with) {
  sprintf("@describeIn compare_with %s.", describe_compare_with(what, with))
}


# Construct a description for any of the compare_git functions
describe_compare_git <- function(what, what_for = "") {
  what <- switch(
    what,
    working = "the local working copy against a specific Git revision",
    revisions = "changes between arbitrary Git revisions"
  )
  what_for <- switch(
    what_for,
    active_file = " for the active file",
    active_project = " for the active project",
    ""
  )
  paste0("Compares ", what, what_for)
}


# Create a @describeIn tag for any compare_git function
man_describeIn_compare_git <- function(what, what_for = "") {
  sprintf("@describeIn compare_git %s.", describe_compare_git(what, what_for))
}
