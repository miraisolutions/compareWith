# with_addin_errors ----
context("with_addin_errors")

test_that("Errors are correctly customized", {
  expect_error(
    with_addin_errors(stop("Something wrong."), "My Addin"),
    "^\\Q'My Addin' - Something wrong.\\E$"
  )
})


# addins_factory ----
context("addin_factory")

test_that("Addins factory constructs a function with 'addin' attribute", {
  addin_fun <- addin_factory("My Addin", {
    a <- LETTERS
    tolower(a)
  })
  expect_is(addin_fun, "function")
  expect_identical(attr(addin_fun, "addin"), "My Addin")
  expect_identical(addin_fun(), letters)
})

test_that("Addins factory returns a function with customized errors", {
  addin_fun <- addin_factory("My Addin", stop("Something wrong."))
  expect_error(
    addin_fun(),
    "^\\Q'My Addin' - Something wrong.\\E$"
  )
})

# RStudio addins ----
context("RStudio addins")

addins <- read.dcf(system.file("rstudio/addins.dcf", package = "compareWith"))
.get_binding_fun <- function(binding) {
  get(
    binding, envir = asNamespace("compareWith"),
    mode = "function", inherits = FALSE
  )
}

test_that("Addins binding functions exist", {
  for (binding in addins[, "Binding"]) {
    binding_fun <- expect_error(
      regexp = NA, # no error
      .get_binding_fun(binding)
    )
  }
})

test_that("Addins names used in the binding functions are corrrect", {
  for (i in seq_len(nrow(addins))) {
    addin <- addins[i, "Name"]
    binding_fun <- .get_binding_fun(addins[i, "Binding"])
    expect_equivalent(
      addin, attr(binding_fun, "addin"),
      info = addin
    )
  }
})
