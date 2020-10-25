#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

# Create directory to see intermediary artifacts and check they look good
rm -rf ../../${validation_api_image_name}
mkdir ../../${validation_api_image_name}

cloud-build-local \
    --config=../${validation_config} \
    --dryrun=false \
    --write-workspace=../../${validation_api_image_name} \
    --substitutions=_IMAGE_NAME_=${validation_api_image_name},_REGION_=${validation_api_service_region},_RUN_NAME_=${validation_api_service_name} \
    ..
