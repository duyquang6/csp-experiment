#!/bin/bash
source config.sh

gcloud -q workflows delete $WORKFLOW
