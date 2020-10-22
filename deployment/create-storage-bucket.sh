#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

gsutil mb \
    -p ${project_id} \
    -c ${storage_bucket_class} \
    -l ${storage_bucket_location} \
    -b ${storage_bucket_uniform_access} \
    gs://${storage_bucket_name}
