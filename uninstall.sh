helm uninstall   $(helm list -aq)
kubectl delete -f oai-ueransim2.yaml
kubectl delete -f oai-ueransim.yaml
