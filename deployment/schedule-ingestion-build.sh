#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

ingestion_continuous_development_trigger_id=$(gcloud beta builds triggers list --filter="name=${ingestion_continuous_development_trigger_name}" | grep "id" | awk '{ print $2 }')

gcloud scheduler jobs create http ${project_id}-${ingestion_continuous_development_trigger_name} \
    --schedule="0 0 * * *" \
    --uri="https://cloudbuild.googleapis.com/v1/projects/${project_id}/triggers/${ingestion_continuous_development_trigger_id}:run" \
    --http-method=post \
    --message-body="${ingestion_scheduler_message_body}" \
    --oauth-service-account-email="${project_id}@appspot.gserviceaccount.com" \
    --oauth-token-scope="https://www.googleapis.com/auth/cloud-platform"
