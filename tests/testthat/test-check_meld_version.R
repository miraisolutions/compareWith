context("check_meld_version")

test_that("The version of Meld is returned", {
  # at the same time, test there is no error when checking version
  meld_ver <- expect_error(check_meld_version(), NA)
  # and possibly skip the other tests
  skip_if(inherits(meld_ver, "error"), "Error checking the Meld version")
  # we expect a character string with Meld + version
  expect_is(meld_ver, "character")
  expect_length(meld_ver, 1L)
  expect_match(
    meld_ver,
    "^[Mm]eld\\s*\\d+(\\.\\d+)*$"
  )
})

test_that("Error when Meld installation not detected", {
  # mimick behavior by calling `me_ld`
  expect_error(
    check_meld_version(meld = "me_ld"),
    "Unable to detect a Meld installation.*instructions.*README"
  )
})

test_that("Error with non-working Meld installation", {
  # mimick behavior by calling `meld` with an invalid option
  expect_error(
    suppressWarnings(
      check_meld_version(option = "--ver_sion")
    ),
    "Meld installation not working.*instructions.*README"
  )
})

test_that("A warning is produced with the output of non-working Meld", {
  expect_warning(
    # prevent error to test the message only
    tryCatch(check_meld_version(option = "--ver_sion"), error = invisible),
    "error.*option", ignore.case = TRUE
  )
})
