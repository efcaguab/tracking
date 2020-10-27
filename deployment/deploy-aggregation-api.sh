#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

# Create directory to see intermediary artifacts and check they look good
rm -rf ../../${aggregation_api_image_name}
mkdir ../../${aggregation_api_image_name}

cloud-build-local \
    --config=../${aggregation_config} \
    --dryrun=false \
    --write-workspace=../../${aggregation_api_image_name} \
    --substitutions=_IMAGE_NAME_=${aggregation_api_image_name},_REGION_=${aggregation_api_service_region},_RUN_NAME_=${aggregation_api_service_name} \
    ..
