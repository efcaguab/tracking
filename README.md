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
    Daily tracks are stored in a Google Storage bucket.
2.  Changes in the storage file are automatically detected and trigger a
    Google pub/sub notification.
3.  The pub/sub message triggers a call to an API processing function
    that reads the data from the storage. The function then validates,
    cleans, and transforms, the data. Finally, the clean data is
    deposited in a Google BigQuery table. The processing function runs
    serverless in Google CloudRun.
