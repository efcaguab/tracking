request_pds_tracks <- function(date, secret){

  response <- httr::GET(
    url = "https://analytics.pelagicdata.com:443",
    path = c(
      "api",
      secret$API_KEY,
      "v1",
      "points",
      as.character(date - 1),
      as.character(date)),
    query = list(deviceInfo = TRUE),
    config = httr::add_headers(`X-API-SECRET` = secret$SECRET)
  )

  content <- httr::content(response, as = "text", encoding = "UTF-8")
  attr(content, "date") <- date
  content
}
