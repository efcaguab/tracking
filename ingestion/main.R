# Read R functions
purrr::walk(list.files("R", full.names = TRUE), source)

# Read and parse parameters
params <- yaml::read_yaml(here::here("params.yaml"))

# DAILY UPDATE ------------------------------------------------------------

pds_params <- params$ingestion$datasets[[1]]
pds_secret <- yaml::read_yaml(pds_params$api$secret)

# If the daily ingestion is only for new data, then a series of historical data
# sets must be available as well. The following section connects to the storage
# bucket and identifies the datasets than need to be downloaded to complete the
# historical record

# Identify all previous updates
hist_dates <- seq(from = as.Date(params$ingestion$datasets[[1]]$start_date),
                  to = Sys.Date(), by = 1)
hist_names <- paste0(params$ingestion$datasets[[1]]$object_prefix, "_", hist_dates)
hist_file_names <- paste0(hist_names, ".", params$ingestion$datasets[[1]]$object_extension)

# Determine data that should be downloaded
googleCloudStorageR::gcs_auth(params$secret$file)
existing_files <- googleCloudStorageR::gcs_list_objects(
  bucket = params$storage$bucket$name)$name
dates_to_download <- hist_dates[!hist_file_names %in% existing_files]

if (length(dates_to_download) > 0) {

  purrr::walk(.x = dates_to_download, .f = function(x){
    retrieved_data <- request_pds_tracks(
      date = x,
      secret = pds_secret)


    data_path <- save_in_tempfile(
      content = retrieved_data,
      prefix = pds_params$object_prefix,
      extension = pds_params$object_extension)

    upload_object_gcs(
      path = data_path,
      bucket = params$storage$bucket$name,
      metadata = list(`Content-Type` = "text/csv"),
      auth_file = params$secret$file)

    Sys.sleep(60)
  })
}
