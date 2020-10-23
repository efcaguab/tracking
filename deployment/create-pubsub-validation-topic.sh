#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

gcloud pubsub topics create ${validation_pubsub_topic_name} \
    --project=${project_id}
