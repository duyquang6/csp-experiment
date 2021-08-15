#!/bin/bash
source config.sh

gcloud workflows deploy $WORKFLOW --source=$WORKFLOW_FILE \
--service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com