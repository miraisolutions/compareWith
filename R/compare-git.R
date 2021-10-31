#' Directory comparison between commits
#'
#' Compare directory to itself in another commit
#'
#' @param commit_1 Name (sha1, tag) of the origin commit to compare to (left)
#' @param commit_2 Name (sha1, tag) of the destination commit to compare (right)
#'
#' @details
#' For instance, use "" for the current state, "HEAD" for the last commit or
#'  "master" to compare to branch master.
#'
#' Add new files to git if you want to see them in the comparison
#' (with git add <file> or Staged in RStudio git pane)
#'
#' @name compare_commit
#' @export
compare_commit <- function(commit_1 = "HEAD", commit_2 = NULL) {
  compare_git_difftool(commit_1, commit_2)
}

compare_git_difftool <- function(commit_1 = NULL, commit_2 = NULL) {

  # from git 1.7.11
  # git difftool -t meld -d master..mycommit
  diff_commits <- paste(c(commit_1, commit_2), collapse = "..")
  git_args <- c("difftool", "-t", "meld", "-d", diff_commits, "--")


  ret <- sys::exec_background(
    "git", args = git_args,
    std_out = TRUE, std_err = TRUE
  )

  invisible(ret)
}

#' @param branch_1 Name of the origin branch to compare to (left)
#' @param branch_2 Name of the destination branch to compare (right)
#' @export
#' @name compare_commit
compare_branch <- function(branch_1 = "master", branch_2 = "") {

  compare_commit(commit_1 = branch_1, commit_2 = branch_2)

}

#' Compare commits with interactive choice
#' @param ask_right Logical. Whether to ask for a second commit to compare.
#' FALSE will compare to current state.
compare_commit_interactive <- function(ask_right = TRUE) {
  left <- rstudioapi::showPrompt(title = "Left commit or branch",
                                 message = "source commit or branch (master, HEAD, <sha1>, ...)", default = "master")
  if (isTRUE(ask_right)) {
    right <- rstudioapi::showPrompt(title = "Right commit or branch",
                                    message = "destination commit or branch (master, HEAD, <sha1>, ...)",
                                    default = "HEAD")
  } else {
    right <- NULL
  }
  compare_commit(left, right)
}

