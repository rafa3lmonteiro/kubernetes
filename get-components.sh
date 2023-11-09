#!/bin/bash
# Script to get images version of Boilerplate components
# 08/11/2023
# Rafael Monteiro

PWD=/home/rafael/boilerplate/files
NS=$PWD/namespaces
IMGS=$PWD/images-all-ns

# clean image file
echo > $IMGS

# Gerando a lista de Pods dos namespaces 
# (istio-system, velero, cert-manager, flux-system)
kubectl get deploy -n istio-system |grep -v NAME |awk '{print $1}' > $NS/istio-system
kubectl get deploy -n velero |grep -v NAME |awk '{print $1}' > $NS/velero
kubectl get deploy -n cert-manager |grep -v NAME |awk '{print $1}' > $NS/cert-manager
kubectl get deploy -n flux-system |grep sealed |grep -v NAME |awk '{print $1}' > $NS/flux-system

# istio-system
echo "Namespace: istio-system" >> $IMGS
echo "--------------------------------" >> $IMGS
for a in $(cat $NS/istio-system); 
	do 
		echo "$a --> $(kubectl describe deploy $a -n istio-system |grep Image: |grep -v configmap-reload |awk '{print $2}')"  >> $IMGS; 
	done

# velero
echo -e "\nNamespace: velero" >> $IMGS
echo "--------------------------------" >> $IMGS
for b in $(cat $NS/velero); 
	do 
		echo "$b --> $(kubectl describe deploy $b -n velero |grep Image: |grep -v plugin-for-microsoft |awk '{print $2}')"  >> $IMGS;  
	done;

# cert-manager
echo -e "\nNamespace: cert-manager" >> $IMGS
echo "--------------------------------" >> $IMGS
for c in $(cat $NS/cert-manager); 
	do 
		echo "$c --> $(kubectl describe deploy $c -n cert-manager |grep Image: |awk '{print $2}')"  >> $IMGS;
	done;

# flux-system
echo -e "\nNamespace: flux-system" >> $IMGS
echo "--------------------------------" >> $IMGS
for d in $(cat $NS/flux-system); 
	do 
		echo "$d --> $(kubectl describe deploy $d -n flux-system |grep Image: |awk '{print $2}')"  >> $IMGS; 
	done;

#echo "$(cat $IMGS |sort |uniq)" > $IMGS
