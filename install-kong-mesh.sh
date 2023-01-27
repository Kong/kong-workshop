#!/bin/bash

while getopts ":g:" arg; do
  case $arg in
    g) GLOBAL_CP_IP=$OPTARG;;
  esac
done

CONTEXT=kind-kong
kubectl create namespace kong-mesh-system --context $CONTEXT
kubectl create secret generic kong-mesh-license -n kong-mesh-system --from-file=license.json --context $CONTEXT

helm repo add kong-mesh https://kong.github.io/kong-mesh-charts

# install Kong Mesh
helm upgrade -i -n kong-mesh-system kong-mesh kong-mesh/kong-mesh \
    --values values-dev-zone.yaml \
    --set kuma.controlPlane.kdsGlobalAddress=grpcs://$GLOBAL_CP_IP:5685 \
    --kube-context $CONTEXT
