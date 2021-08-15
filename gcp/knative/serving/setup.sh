#!/bin/bash

# Install Knative CLI


# Setup Knative cluster
export KNATIVE_VERSION="0.25.0"
export KNATIVE_NET_KOURIER_VERSION="0.25.0"

# Install CRD Knative
kubectl apply -f https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-crds.yaml
kubectl wait --for=condition=Established --all crd

# Install Knative serving to k8s cluster
kubectl apply -f https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-core.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-serving > /dev/null

# Install Kourier to k8s cluster
kubectl apply -f https://github.com/knative/net-kourier/releases/download/v$KNATIVE_NET_KOURIER_VERSION/kourier.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n kourier-system
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-serving


EXTERNAL_IP=$(kubectl -n kourier-system get service kourier -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
KNATIVE_DOMAIN="$EXTERNAL_IP.nip.io"

# Config knative domain using NIP io domain
kubectl patch configmap -n knative-serving config-domain -p "{\"data\": {\"$KNATIVE_DOMAIN\": \"\"}}"

# Config Knative use Kourier Loadbalancer
kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}' 

# Verify Knative serving & kourier setup successfully
kubectl get pods -n knative-serving
kubectl get pods -n kourier-system
kubectl get svc  -n kourier-system