#' Git comparison
#'
#' Compare the local working copy against a Git revision, or the changes between
#' arbitrary Git revisions. Revisions can be specified as "HEAD", branch names,
#' commit SHA, etc. (see 'Details' below).
#'
#' @param path Path to a specific file or directory to be compared. If `NULL`,
#'   the whole repository is compared.
#' @param prompt Whether to prompt for revisions via [showPrompt()], using the
#'   provided values as defaults.
#'
#' @details
#' The functionality is based on
#' [`git difftool`](https://git-scm.com/docs/git-difftool) using
#' [Meld](http://meldmerge.org/) as external diff tool.
#'
#' Comparisons are based on the Git repository detected for the current working
#' directory, and `path` must be part of the repository.
#'
#' Revision arguments can be specified in a number of ways, see
#' '[Specifying revisions](https://git-scm.com/docs/gitrevisions#_specifying_revisions)'
#' in the Git documentation. In particular, the following are relevant revision
#' specifications:
#'
#' - `HEAD`: The last commit.
#' - `<sha>`: The hexadecimal SHA of any commit.
#' - `<branch>`, `<tag>`: The name of a branch or tag, e.g. `main`,`master`,
#' `v1.0.1`.
#' - `@{upstream}`, `@{u}`: The upstream remote of the current branch.
#' - `<branch>@{upstream}`, `<branch>@{u}`: The upstream remote of `<branch>`,
#' e.g. `main@{u}`.
#' - `<revision>~<n>`: `<n>` commits before any specified `<revision>`, e.g.
#' `HEAD~1`, `main~1`.
#'
#' @template return-git-difftool
#'
#' @seealso [RStudio addins][compareWith-addins] for file and project comparison
#'   with support for version control.
#'
#' @example man-roxygen/ex-compare_git.R
#'
#' @name compare_git
NULL


#' @eval man_describeIn_compare_git("working")
#' @param revision The Git revision to compare against (see 'Details'). The
#'   default refers to the last commit (`HEAD`).
#'
#' @export
compare_with_git <- function(revision = "HEAD",
                             path = NULL,
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
#'   (`revision_compare` vs. `revision_against`) (see 'Details'). With default
#'   values, the last commit (`HEAD`) is compared against the upstream remote for
#'   the current branch (`@{upstream}`).
#'
#' @export
compare_git_revisions <- function(revision_compare = "HEAD",
                                  revision_against = "@{upstream}",
                                  path = NULL,
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
  compare_with_git(path = get_active_file(), prompt = prompt)
}


#' @eval man_describeIn_compare_git("working", "active_project")
#'
#' @export
compare_project_with_git <- function(prompt = TRUE) {
  compare_with_git(path = get_active_project(), prompt = prompt)
}


#' @eval man_describeIn_compare_git("revisions", "active_project")
#'
#' @export
compare_project_git_revisions <- function(prompt = TRUE) {
  compare_git_revisions(path = get_active_project(), prompt = prompt)
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
  explain_revision <- paste(
    " - ", # list-like
    c(
      "HEAD (last commit)",
      "@{upstream} / @{u} (current upstream remote)",
      "<branch> (e.g. main, develop)",
      "<branch>@{u} (upstream remote of <branch>)",
      "commit <sha>",
      NULL # for convenience with trailing commas in case of reshuffling
    ),
    collapse = "\n"
  )

  git_commit <- rstudioapi::showPrompt(
    title = title,
    message = paste0(
      title, ":\n\n",
      explain_revision, "\n\n",
      "See ?compareWith::compare_git\n"
    ),
    default = default
  )
  stop_if_null(git_commit, paste0("You must specify the ", tolower(title), "."))
}
