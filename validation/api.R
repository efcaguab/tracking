#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)

#* @apiTitle Penang data validation

#* Transform data
#* @post /tracking-validation
#* @param message a pub/sub message
function(message=NULL){

  cat("Received message", as.character(list(message = message)),"\n")

  # If message has not been properly parsed, address that
  if (class(message) == "character") {
    message <- jsonlite::fromJSON(message)
  }

  # Only continue if object has been created or overwritten
  if (message$attributes$eventType == "OBJECT_DELETE") {
    message("Notification of object deleted received")
    return(TRUE)
  }

  # Check that we know about that datasetsd
  this_bucket_datasets <- purrr::keep(
    .x = params$datasets,
    .p = ~ .$bucket==message$attributes$bucketId)
  if (length(this_bucket_datasets) == 0)
    stop("This bucket is not supported for auto-transformation")

  googleCloudRunner::cr_plumber_pubsub(message, validate_data)
}

validate_data <- function(x){
  # If message has not been properly parsed, address that
  if (class(x) == "character") {
    x <- jsonlite::fromJSON(x)
  }

  params <- yaml::read_yaml("params.yaml")

  cat("Data parameters:", as.character(list(data = x)), "\n")

  # Build URI
  this_dataset$source_uri <- paste0("gs://", x$bucket, "/", x$name)
  this_dataset$name <- x$name

  upload_to_bq()

  return("hello world")
}

upload_to_bq <- function(){
  bigrquery::bq_auth(path = params$secret$file)
}
