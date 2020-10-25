#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

validation_api_service_url=$(gcloud run services list --platform=managed | grep "${validation_api_service_name}" | awk '{ print $4 }')

gcloud pubsub subscriptions create ${validation_pubsub_subscription_name} \
   --topic ${validation_pubsub_topic_name} \
   --topic-project=${project_id} \
   --push-endpoint=${validation_api_service_url}/${validation_endpoint} \
   --push-auth-service-account=cloud-run-pubsub-invoker@${project_id}.iam.gserviceaccount.com \
   --ack-deadline=${validation_pubsub_subscription_acknowledgement_deadline} \
   --min-retry-delay=${validation_pubsub_subscription_retry_delay_min} \
   --max-retry-delay=${validation_pubsub_subscription_retry_delay_max}
