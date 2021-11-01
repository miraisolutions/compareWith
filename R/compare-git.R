# TODO: review documentation

#' Git comparison
#'
#' Compare the local working copy against a Git revision, or the changes between
#' arbitrary Git revisions. Revisions can be specified as "HEAD", branch names,
#' commit SHA, etc. (see 'Details' TODO).
#'
#' TODO: return, details
#'
#' @param path Path to a specific file or directory to be compared. If `NULL`,
#'   the whole repository is compared.
#' @param prompt Whether to prompt for revisions via [showPrompt()]).
#'
#' @seealso [RStudio addins][compareWith-addins] for file and project comparison
#'   with support for version control (TODO).
#'
#' @example man-roxygen/ex-compare_git.R
#'
#' @name compare_git
NULL


#' @eval man_describeIn_compare_git("working")
#' @param revision The Git revision to compare against (see 'Details' TODO)
#'
#' @export
compare_with_git <- function(path = NULL,
                             revision = "HEAD",
                             prompt = FALSE) {

  # make sure `path` exists if specified
  if (!is.null(path)) check_path(path)
  # prompt for revision
  if (isTRUE(prompt)) {
    revision <- prompt_git_revision(
      "Git revision to compare against", default = revision
    )
  }
  compare_git_difftool(path = path, revision)
}


#' @eval man_describeIn_compare_git("revisions")
#' @param revision_compare,revision_against The Git revisions to compare
#'   (`revision_compare` vs. `revision_against`) (see 'Details' TODO)
#'
#' @export
compare_git_revisions <- function(path = NULL,
                                  revision_compare = "HEAD",
                                  revision_against = "@{upstream}",
                                  prompt = FALSE) {

  # make sure `path` exists if specified
  if (!is.null(path)) check_path(path)
  # prompt for revisions
  if (isTRUE(prompt)) {
    revision_compare <- prompt_git_revision(
      "Git revision for comparison", default = revision_compare
    )
    revision_against <- prompt_git_revision(
      "Git revision to compare against", default = revision_against
    )
  }
  # NOTE: git diff(tool) compares `commit_2` against `commit_1`
  compare_git_difftool(path = path, revision_against, revision_compare)
}


#' @eval man_describeIn_compare_git("working", "active_file")
#'
#' @export
compare_active_file_with_git <- function(prompt = TRUE) {
  compare_with_git(get_active_file(), prompt = prompt)
}


#' @eval man_describeIn_compare_git("working", "active_project")
#'
#' @export
compare_project_with_git <- function(prompt = TRUE) {
  compare_with_git(get_active_project(), prompt = prompt)
}


#' @eval man_describeIn_compare_git("revisions", "active_project")
#'
#' @export
compare_project_git_revisions <- function(prompt = TRUE) {
  compare_git_revisions(get_active_project(), prompt = prompt)
}


compare_git_difftool <- function(commit_1 = NULL, commit_2 = NULL, path = NULL,
                                 tool = "meld", dir_diff = TRUE, options = NULL) {
  # We use this form (see `git difftool --help`, `git diff --help`)
  # git difftool --tool <tool> [<options>] <commit>..<commit> -- [<path>...]
  diff_commits <- paste(c(commit_1, commit_2), collapse = "..")
  if (!is.null(path)) path <- normalizePath(path)
  git_args <- c(
    "difftool", "--tool", tool,
    "--no-prompt", # never prompt before launching the tool
    if (isTRUE(dir_diff)) "--dir-diff",
    options,
    diff_commits, "--", path
  )
  ret <- sys::exec_background(
    "git", args = git_args,
    std_out = TRUE, std_err = TRUE
  )
  invisible(ret)
}


# Returns a Git revision, triggers an error message if null
prompt_git_revision <- function(title, default = "") {
  git_commit <- rstudioapi::showPrompt(
    title = title,
    message = paste0(
      title, ": master, HEAD, <sha1>, ..."
    ),
    default = default
  )
  stop_if_null(git_commit, paste0("You must specify the ", tolower(title), "."))
}
