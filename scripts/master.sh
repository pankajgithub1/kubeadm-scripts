#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

MASTER_IP="172.31.29.92"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

sudo kubeadm config images pull --image-repository  "registry.k8s.io"

echo "Preflight Check Passed: Downloaded All Required Images"

sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Claico Network Plugin Network 

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
