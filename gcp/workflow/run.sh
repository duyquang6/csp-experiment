#!/bin/bash
source config.sh

gcloud workflows run $WORKFLOW
