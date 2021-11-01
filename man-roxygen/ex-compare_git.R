\dontrun{
  # compare working copy with the last commit (HEAD)
  compare_with_git()
  # compare working copy of a given path with the last commit
  compare_with_git(path = "path/to/compare")
  # compare working copy of the current directory with the last commit
  compare_with_git(path = getwd())
  # compare working copy of a specific file with the last commit
  compare_with_git(path = "bar/foo.file")
  # compare working copy, prompting for the revision to compare with
  compare_with_git(prompt = TRUE)
  # compare working copy with branch "main"
  compare_with_git("main")
  # compare working copy with the current upstream remote
  compare_with_git("@{upstream}")
  # compare working copy with the second-last commit
  compare_with_git("HEAD~1")

  # compare active file, prompting for the revision to compare against
  compare_active_file_with_git()
  # compare active project, prompting for the revision to compare against
  compare_project_with_git()

  # compare last commit (HEAD) against current upstream remote (default)
  compare_git_revisions()
  # compare last commit against current upstream remote for a given path
  compare_git_revisions(path = "path/to/compare")
  # prompt for the revisions to compare
  compare_git_revisions(prompt = TRUE)
  # compare last commit against "main" branch
  compare_git_revisions(revision_against = "main")
  # compare last commit against previous commit
  compare_git_revisions("HEAD", "HEAD~1")
  # compare local "master" branch against the upstream remote for a given path
  compare_git_revisions(path = "path/to/compare", "master", "master@{upstream}")

  # prompt for the revisions to compare for the active project
  compare_project_git_revisions()
}
