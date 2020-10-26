upload_object_gcs <- function(path, bucket, auth_file, metadata = NULL){
  googleCloudStorageR::gcs_auth(auth_file)

  if (!is.null(metadata)) {
    metadata <- googleCloudStorageR::gcs_metadata_object(
      object_name = basename(path),
      metadata = metadata)
  }

  googleCloudStorageR::gcs_upload(
    file = path,
    bucket = bucket,
    type = "text/csv",
    name = basename(path),
    predefinedAcl = "default",
    object_metadata = metadata)
}
