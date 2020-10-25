#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

# Give the invoker service account permission to invoke your pubsub-tutorial service:
gcloud run services add-iam-policy-binding ${validation_api_service_name} \
   --member=serviceAccount:cloud-run-pubsub-invoker@${project_id}.iam.gserviceaccount.com \
   --role=roles/run.invoker \
   --platform managed \
   --region=${validation_api_service_region}
