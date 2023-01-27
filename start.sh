#!/bin/bash

#####
# This script install kind and sets the local context to kind-kind,
# which is a tool for running local Kubernetes clusters using Docker
# container “nodes”.
######

set -o errexit


cat <<EOF > /tmp/kind-config.yaml && kind create cluster --config /tmp/kind-config.yaml
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
name: kong
networking:
  apiServerAddress: "0.0.0.0"
  apiServerPort: 16443
nodes:
  - role: control-plane
    kubeadmConfigPatches:
    - |
      kind: InitConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "ingress-ready=true"
    extraPortMappings:
    - listenAddress: "0.0.0.0"
      protocol: TCP
      hostPort: 80
      containerPort: 80
    - listenAddress: "0.0.0.0"
      protocol: TCP
      hostPort: 443
      containerPort: 443
    - listenAddress: "0.0.0.0"
      protocol: TCP
      hostPort: 30001
      containerPort: 30001
    - listenAddress: "0.0.0.0"
      protocol: TCP
      hostPort: 30002
      containerPort: 30002
    - listenAddress: "0.0.0.0"
      protocol: TCP
      hostPort: 30080
      containerPort: 30080
    - listenAddress: "0.0.0.0"
      protocol: TCP
      hostPort: 30010
      containerPort: 30010
EOF

kubectl config use-context kind-kong && kubectl cluster-info
