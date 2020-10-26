#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

gcloud projects add-iam-policy-binding ${project_id} \
    --member="serviceAccount:${service_account_name}@${project_id}.iam.gserviceaccount.com" \
    --role="${service_account_role_bigquery_name}" \
    --condition=None
