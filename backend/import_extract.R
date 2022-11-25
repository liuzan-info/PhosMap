# unzip file and return file path
get_file_path <- function(inputfile, pathname) {
  # if (dir.exists(paste0("tmp/", pathname))) {
  #   unlink(paste0("tmp/", pathname), recursive = TRUE)
  # }
  zip::unzip(
    inputfile$datapath,
    # exdir = paste0("tmp/", pathname)
    exdir = pathname
  )
  namestrs = inputfile$name
  normalizePath(paste0(pathname, "/", substring(namestrs, 0, nchar(namestrs)-4)))
}

# Get a list of file names without suffixes based on the path
get_target_name <- function(path, depth) {
  if(depth == 2) {
    path = normalizePath(list.files(path, full.names = T))
  }
  tmp <- list.files(path)
  substring(tmp, 0, nchar(tmp)-4)
}

