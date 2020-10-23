save_in_tempfile <- function(content, prefix, extension){
  content_date <- attr(content, "date")
  file_name <- paste0(prefix, "_",content_date, ".", extension)
  dir_name <- tempdir()
  path <- file.path(dir_name, file_name)
  writeLines(text = retrieved_data, con = path)
  path
}
