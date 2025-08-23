#!/bin/bash
echo "minikube"
minikube version
echo "================================================"
echo "kubectl"
kubectl version
echo "================================================"
echo "aws cli"
aws --version
echo "================================================"
echo "helm"
helm version
echo "================================================"
echo "docker"
docker --version
echo "================================================"
echo "stern"
stern --version
echo "================================================"
echo "terraform"
terraform --version
echo "================================================"
echo "vagrant"
vagrant -v
echo "================================================"
echo "kvm"
virsh --version
echo "================================================"

