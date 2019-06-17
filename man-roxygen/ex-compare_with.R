\dontrun{
# compare a given file, select other file from the same directory
compare_with_other("~/bar/foo.file")
# compare a given file, select other file from the working directory
compare_with_other("~/bar/foo.file", location = getwd())
# compare a given file, select other file from home directory
compare_with_other("~/bar/foo.file", location = "~")
# compare a given directory, select other directory from the parent directory
compare_with_other("~/foo/bar/")
# compare a given directory, select other directory from a different location
compare_with_other("~/foo/bar/", location = "/home/me/dir")
# compare active file, select other file from the same directory
compare_active_file_with_other()
# compare active file, select other file from the working directory
compare_active_file_with_other(location = getwd())
# compare active file, select other file from the home directory
compare_active_file_with_other(location = "~")
# compare a given file under version control with the repository version
compare_with_repo("~/bar/foo.file")
# compare a given directory under version control with the repository version
compare_with_repo("~/foo/bar")
# compare active file under version control with the repository version
compare_active_file_with_repo()
# compare current project with the version control repository
compare_project_with_repo()
}
