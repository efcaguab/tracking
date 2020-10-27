#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

gsutil notification create \
    -t ${aggregation_pubsub_topic_name} \
    -f ${aggregation_pubsub_notification_format} \
    -e ${aggregation_pubsub_notification_event} \
    -p ${ingestion_datasets__object_prefix[0]} \
    gs://${storage_bucket_name}
