#!/bin/bash

source config.sh

# Enable Workflow service
# gcloud services enable workflows.googleapis.com

# # Create workflow service account
# gcloud iam service-accounts create $SERVICE_ACCOUNT

# Grant log writer permission to service_account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member "serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
    --role "roles/logging.logWriter"

