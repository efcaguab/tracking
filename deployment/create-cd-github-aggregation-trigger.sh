#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

gcloud beta builds triggers create github --name=${aggregation_continuous_development_trigger_name} \
    --description="${aggregation_continuous_development_trigger_description}" \
    --repo-owner=${aggregation_continuous_development_trigger_repo_owner} \
    --repo-name=${aggregation_continuous_development_trigger_repo_name} \
    --branch-pattern=${aggregation_continuous_development_trigger_branch_pattern} \
    --included-files=${aggregation_continuous_development_trigger_files_included} \
    --build-config=${aggregation_continuous_development_trigger_build_config}
