#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

echo "gs://${project_id}/${storage_bucket_name}"

gsutil iam ch \
    serviceAccount:${service_account_name}@${project_id}.iam.gserviceaccount.com:${service_account_role_storage_name} \
    "gs://${storage_bucket_name}"
