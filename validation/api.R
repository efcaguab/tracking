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

  googleCloudRunner::cr_plumber_pubsub(message, validate_data)
}

validate_data <- function(x){
  # If message has not been properly parsed, address that
  if (class(x) == "character") {
    x <- jsonlite::fromJSON(x)
  }

  params <- yaml::read_yaml("params.yaml")

  cat("Data parameters:", as.character(list(data = x)), "\n")

  upload_to_bq(
    object = x$name,
    bucket = x$bucket,
    project = params$project$id,
    object_col = params$validation$bigquery$raw$coltypes,
    bq_dataset = params$validation$bigquery$raw$dataset,
    bq_table = params$validation$bigquery$raw$table,
    bq_location = params$validation$bigquery$raw$location,
    bq_write_disposition = params$validation$bigquery$raw$write_disposition,
    bq_create_disposition = params$validation$bigquery$raw$create_disposition,
    secret_path = params$secret$file)

  return(0)
}

upload_to_bq <- function(object, bucket, project, object_col, bq_dataset, bq_table,
                         bq_location, bq_write_disposition, bq_create_disposition,
                         secret_path){
  bigrquery::bq_auth(path = secret_path)

  # Check if dataset exists
  dataset_bq <- bigrquery::bq_dataset(project = project, dataset = bq_dataset)
  if (!bigrquery::bq_dataset_exists(dataset_bq)) {
    bigrquery::bq_dataset_create(x = dataset_bq, location = bq_location)
  }

  values <- get_raw_csv(object, bucket, object_col, secret_path)
  table_bq <- bigrquery::bq_table(project, bq_dataset, bq_table)

  bigrquery::bq_table_upload(
    table_bq,
    values,
    write_disposition = bq_write_disposition,
    create_disposition = bq_create_disposition)

}

get_raw_csv <- function(object, bucket, object_col, secret_path){
  googleCloudStorageR::gcs_auth(json_file = secret_path)

  # Download csv data
  values_path <- tempfile(fileext = ".csv")
  values_path <- basename(values_path)
  # Make sure file is deleted
  on.exit(file.remove(values_path))

  googleCloudStorageR::gcs_get_object(object_name = object,
                                      bucket = bucket,
                                      saveToDisk = values_path)
  # Clean column names
  values <- readr::read_csv(values_path, guess_max = 10000,
                            col_types = object_col)
  janitor::clean_names(values)
}
