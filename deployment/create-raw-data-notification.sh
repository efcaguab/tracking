#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

gsutil notification create \
    -t ${validation_pubsub_topic_name} \
    -f ${validation_pubsub_notification_format} \
    -e ${validation_pubsub_notification_event} \
    -p ${ingestion_datasets__object_prefix[0]} \
    gs://${storage_bucket_name}
