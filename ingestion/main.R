# Read R functions
purrr::walk(list.files("R", full.names = TRUE), source)

# Read and parse parameters
params <- yaml::read_yaml(here::here("params.yaml"))

# DAILY UPDATE ------------------------------------------------------------

pds_params <- params$ingestion$datasets[[1]]
pds_secret <- yaml::read_yaml(pds_params$api$secret)

retrieved_data <- request_pds_tracks(
  date = Sys.Date(),
  secret = pds_secret)

data_path <- save_in_tempfile(
  content = retrieved_data,
  prefix = pds_params$object_prefix,
  extension = pds_params$object_extension)

upload_object_gcs(
  path = data_path,
  bucket = params$storage$bucket$name,
  metadata = list(`Content-Type` = "text/csv"),
  auth_file = params$secret$file
)
