# Knative Serving
Setup Knative serving with minikube. Suitable for toying, testing on single host
## Steps:
- Setup minikube (ref [minikube.sh](minikube.sh))
- Setup knative serving & kourier ingress type to k8s (ref [setup.sh](minikube.sh))
- Deploy serverless service:

```
kn service create hello \
--image gcr.io/knative-samples/helloworld-go \
--port 8080 \
--env TARGET=Knative
```
- Testing
```
curl $(kubectl get ksvc hello -o jsonpath='{.status.url}')
```