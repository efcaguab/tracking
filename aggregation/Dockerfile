FROM rocker/r-ver:4.0.3

RUN install2.r googleCloudRunner plumber bigrquery janitor here readr

COPY aggregation /home
COPY auth /home/auth
COPY params.yaml /home/params.yaml
WORKDIR /home

ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('api.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
CMD ["api.R"]
