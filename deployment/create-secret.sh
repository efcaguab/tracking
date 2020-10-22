#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

gcloud secrets create $secret_name \
    --data-file="../${secret_file[0]}"
