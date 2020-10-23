FROM rocker/r-ver:4.0.2

RUN install2.r googleCloudRunner here

COPY ingestion /home
COPY auth /home/auth
COPY params.yaml /home/params.yaml
WORKDIR /home

# CMD Rscript "main.R"
