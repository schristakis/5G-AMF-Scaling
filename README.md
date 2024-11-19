# 5G-AMF-Scaling

## Contact

For help and information for this project refer to this email : Sokratis.Christakis@lip6.fr 

## Overview

In this project you are asked to deploy a fully-operational 5G network using OpenAirInterface(OAI) and Kubernetes. Using Kubernetes means that your different network functions will run as independent containers(Docker) within a microservices environment provided by Kubernetes. The goal of this project is to observe the deployed User Equipments (UEs) that are entering the network. Based on that number, you are asked to scale the number of AMF instances that deal with these new UE subscriptions.

## Getting Started

Clone this repository in your VM 33 (ssh cell@132.227.122.33) to access the files that we have already prepared for you:
```
ssh cell@132.227.122.33
git clone https://gitlab.com/schristakis1/5g-amf-scaling.git
```
Go into the directory and execute the following command to initialize kubernetes cluster and depedencies. !!!WAIT UNITL THE SCRIPT IS DONE!!:
```
bash init.sh
```
After this script finishes continue by installing helm with the following command:
```
bash get_helm.sh
```


The first step is to deploy the 5G Core Network.


Go inside the the folder that you have just cloned and study the files and more specifically the folder oai-5g-core and oai-ueransim.yaml.

- In this project you will have to deploy the 5G Core funtions **in this specific order** : mysql(Database), NRF, UDR, UDM, AUSF, AMF, SMF, UPF.


```
cd 5g-amf-scaling/oai-5g-core
```
In orde to deploy each function you have to execute the following command for each core network function:

```
helm install {network_function_name} {path_of_network_function}
```
For example if you want to deploy the sql database  and then the NRF, UDR you execute:

```
helm install mysql mysql/
helm install nrf oai-nrf/
helm install udr oai-udr/
...
```
It is very important that every after helm command you execute: kubectl get pods in order to see that the respective network function is running, before going to the next one.

In order to uninstall something with helm you execute the following command:
```
helm uninstall {function_name}  ## e.g. helm uninstall udr
```


Afer you deployed all the network functions mentioned above you will be able to connect the UE to the 5G network by executing:

```
kubectl apply -f oai-ueransim.yaml
```

In order to uninstall something with kubectl you execute the following command:
```
kubectl delete -f oai-ueransim.yaml 
```


In order to see if the UE has actually subscribed and received an ip you will have to enter the UE container:

```
kubectl get pods # In order to find the name of the ue_container_name (should look something like this: ueransim-746f446df9-t4sgh)
kubectl exec -ti {ue_container_name} -- bash
```

If everything went well you should be inside the UE container and if you execute ifconfig you should see the following interface:
```
uesimtun0: flags=369<UP,POINTOPOINT,NOTRAILERS,RUNNING,PROMISC>  mtu 1400
        inet 12.1.1.2  netmask 255.255.255.255  destination 12.1.1.2
        inet6 fe80::73e2:e6e6:c3a:3d17  prefixlen 64  scopeid 0x20<link>
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 500  (UNSPEC)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 688 (688.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

If not, something went wrong. If yes, execute the following command to make sure you have connectivity to the internet through your 5G network:
```
ping -I uesimtun0 8.8.8.8
```


If the ping command works, it means that you have successfully deployed a 5G network and connected a UE to it.


## Project goal

As previously mentioned you will have to extend this architecture to connect multiple UEs in the network(hint: oai-ueransim.yaml file) and by doing so, you should be able to see multiple uesimtun* interfaces and not only one like in the example before. Then you will have to change the number of UEs for the values that are in the number_of_ues.txt file. Originally  your network will have only one AMF function, but if the number of UEs is high you will have to scale the AMF deployment to deal with the extra UEs.

Hint: The files you will have to modify are the oai-ueransim.yaml (increase/decrease number of UEs) and manually scale the AMF intances.
It is on you whether to create a script to monitor the number of UEs and scale the AMF instances accordingly.


The scaling should work as follows:

- if number_of_ues <= 5  --> 1 AMF instances
- if number_of_ues 5 < number_of_ues <= 10  --> 2 AMF instances
- if number_of_ues 10 < number_of_ues --> 3 AMF instances
