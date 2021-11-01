\dontrun{
  # compare working copy with the last commit (HEAD)
  compare_with_git()
  # compare working copy of a given path with the last commit
  compare_with_git("path/to/compare")
  # compare working copy of the current directory with the last commit
  compare_with_git(getwd())
  # compare working copy of a specific file with the last commit
  compare_with_git("bar/foo.file")
  # compare working copy, prompting for the revision to compare with
  compare_with_git(prompt = TRUE)
  # compare working copy with branch "main"
  compare_with_git(revision = "main")
  # compare working copy with the current upstream remote
  compare_with_git(revision = "@{upstream}")
  # compare working copy with the second-last commit
  compare_with_git(revision = "HEAD~1")

  # compare active file, prompting for the revision to compare against
  compare_active_file_with_git()
  # compare active project, prompting for the revision to compare against
  compare_project_with_git()

  # compare last commit (HEAD) against current upstream remote (default)
  compare_git_revisions()
  # compare last commit against current upstream remote for a given path
  compare_git_revisions("path/to/compare")
  # prompt for the revisions to compare
  compare_git_revisions(prompt = TRUE)
  # compare last commit against "main" branch
  compare_git_revisions(revision_against = "main")
  # compare last commit against "main" branch
  compare_git_revisions(revision_against = "main")
  # compare last commit against previous commit for a given path
  compare_git_revisions("path/to/compare", "HEAD", "HEAD~1")
  # compare local "master" branch against the upstream remote for a give path
  compare_git_revisions("path/to/compare", "master", "master@{upstream}")

  # prompt for the revisions to compare for the active project
  compare_project_git_revisions()
}
