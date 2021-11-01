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
compare_commit <- function (commit_1 = "HEAD", commit_2 = "")
{
  # from git 1.7.11
  # git difftool -t meld -d master..mycommit

if (commit_2 == "") { # compare with current state
  args <- c("difftool", "-t", "meld", "-d", paste0(commit_1))
} else {
  args <- c("difftool", "-t", "meld", "-d", paste0(commit_1, "..", commit_2))
}

  ret <- sys::exec_background(
    "git",
    args = args,
    std_out = TRUE, std_err = TRUE)

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
    right <- ""
  }
  compare_commit(left, right)
}

addin_branch <- addin_factory(
  addin = "Compare commits or branches...",
  compare_commit_interactive(ask_right = TRUE)
)

addin_branch_current <- addin_factory(
  addin = "Compare current with commit or branch...",
  compare_commit_interactive(ask_right = FALSE)
)

