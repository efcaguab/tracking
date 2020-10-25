Peskas: tracking domain
================

This repository contains code for the tracking data pipeline.

## Pipeline description

*Pipeline input(s)*: Tracking data obtained from the Pelagic Data
Systems API.

*Pipeline product(s)*: A BigQuery dataset with clean catch data. The
dataset includes tables with *(i)* the full clean dataset.

**Stages**:

1.  Input data is retrieved on a daily basis at midnight (UTM) by a
    Google Build Service from the Pelagic Data Systems restful API.
    Daily tracks are stored in a Google Storage bucket. In addition, the
    storage bucket is checked every time in case missing days exist.
2.  Changes in the storage bucket that match the daily update prefix are
    automatically detected and trigger a Google pub/sub notification.
3.  The pub/sub message triggers a call to an API processing function.
    This API reads the data from the storage. The function then
    validates, cleans, and transforms, the data. Finally, the clean data
    is deposited in a Google BigQuery table. The processing function
    runs serverless in Google CloudRun.

## Deployment steps

  - [Create a service
    account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
    for this domain:
    [`deployment/create-service-account.sh`](deployment/create-service-account.sh)
  - [Create a
    key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)
    for the service account:
    [`deployment/create-service-account-key.sh`](deployment/create-service-account-key.sh)
  - [Upload the service account
    key](https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#secretmanager-create-secret-cli)
    to Google Secret Manager to simplify reuse:
    [`deployment/create-secret.sh`](deployment/create-secret.sh)
  - Upload the Pelagic Data Systems secret information to Google Secret
    Manager. This must be done manually. The secret information should
    be in a yaml format and have the field “SECRET” got the X-API-SECRET
    in the header, and the field “API\_KEY” for the API KEY that’s part
    of the path.
  - [Create the
    storage](https://cloud.google.com/storage/docs/creating-buckets)
    bucket:
    [`deployment/create-storage-bucket.sh`](deployment/create-storage-bucket.sh)
  - [Grant service account
    permissions](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
    to admin storage objects:
    [`deployment/grant-service-account-storage-permissions.sh`](deployment/grant-service-account-storage-permissions.sh)
  - [Create topic](https://cloud.google.com/pubsub/docs/admin) for
    message passing between the storage bucket and the validation API:
    [`deployment/create-pubsub-validation-topic.sh`](deployment/create-pubsub-validation-topic.sh)
  - [Enable
    notifications](https://cloud.google.com/storage/docs/gsutil/commands/notification)
    for raw data updates to the validation topic:
    [`deployment/create-raw-data-notification.sh`](deployment/create-raw-data-notification.sh)
  - Deploy data validation API using a [local
    build](https://cloud.google.com/cloud-build/docs/build-debug-locally).
    This will create the url for the service:
    [`deployment/deploy-validation-api.sh`](deployment/deploy-validation-api.sh)
  - If its the first time running pubsub push service,
    [setup](https://cloud.google.com/pubsub/docs/push) pubsub
    permissions and create and invoker account for push notifications,
    skip otherwise.
  - Grant permissions to invoke validation api:
    [`deployment/grant-validation-api-permisions.sh`](deployment/grant-validation-api-permisions.sh)
