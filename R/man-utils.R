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
