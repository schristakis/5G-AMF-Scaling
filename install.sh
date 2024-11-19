sudo sysctl -p
kubectl label nodes socratis  node=master  --overwrite
kubectl label nodes sokratis-worker1  node=worker1  --overwrite
kubectl label nodes sokratis-worker2  node=worker2 --overwrite
kubectl label nodes sokratis-worker  node=worker0 --overwrite
cd charts/oai-5g-core/
helm install mysql mysql/ --set nodeSelector.node=master
sleep 5
helm install nrf  oai-nrf/ --set nodeSelector.node=master
sleep 5
helm install udr  oai-udr/ --set nodeSelector.node=master
sleep 5
helm install udm oai-udm/ --set nodeSelector.node=master 
sleep 5
helm install ausf oai-ausf/ --set nodeSelector.node=master
sleep 5
helm install amf oai-amf/ --set nodeSelector.node=master
sleep 5
helm install smf oai-smf/ --set nodeSelector.node=master
sleep 5
helm install upf oai-upf/ --set nodeSelector.node=master
sleep 5
helm install traffic oai-traffic-server --set nodeSelector.node=master
cd ../..
sleep 5
kubectl apply -f oai-ueransim.yaml
