#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
source yaml.sh

create_variables ../params.yaml

gcloud beta builds triggers create github --name=${ingestion_continuous_development_trigger_name} \
    --description="${ingestion_continuous_development_trigger_description}" \
    --repo-owner=${ingestion_continuous_development_trigger_repo_owner} \
    --repo-name=${ingestion_continuous_development_trigger_repo_name} \
    --branch-pattern=${ingestion_continuous_development_trigger_branch_pattern} \
    --included-files=${ingestion_continuous_development_trigger_files_included} \
    --build-config=${ingestion_continuous_development_trigger_build_config}
