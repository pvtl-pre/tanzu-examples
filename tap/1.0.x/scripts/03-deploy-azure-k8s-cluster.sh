#!/bin/bash
set -e -o pipefail
shopt -s nocasematch;

TKG_LAB_SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$TKG_LAB_SCRIPTS/set-env.sh"

RESOURCE_GROUP=$(yq e .azure.resource_group $PARAMS_YAML)
CLUSTER_NAME=$(yq e .azure.aks_cluster_name $PARAMS_YAML)
export KUBECONFIG="generated/kubeconfig.yaml"

#echo "## Checking providers Microsoft.OperationsManagement and Microsoft.OperationalInsights are registered"

#OP_MAN_REGISTERED=$(az provider show -n Microsoft.OperationsManagement -o json | jq -r '.registrationState')

#if [[ "${OP_MAN_REGISTERED}" != 'registered' ]]; then
#  echo "## Registering provider Microsoft.OperationsManagement"
#  az provider register --namespace Microsoft.OperationsManagement --wait
#fi

#OP_INS_REGISTERED=$(az provider show -n Microsoft.OperationalInsights -o json | jq -r '.registrationState')

#if [[ "${OP_MAN_REGISTERED}" != 'registered' ]]; then
#  echo "## Registering provider Microsoft.OperationalInsights"
#  az provider register --namespace Microsoft.OperationalInsights --wait
#fi


CLUSTER_EXISTS=$(az aks list | jq ".[] | contains({name: \"$CLUSTER_NAME\"})")

if [[ -z "${CLUSTER_EXISTS}" || "${CLUSTER_EXISTS}" == 'false' ]]; then
  echo "## Creating AKS cluster '$CLUSTER_NAME'"
  az aks create --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --node-vm-size standard_a8_v2 --node-count 4 --yes
else
  echo "## AKS cluster '$CLUSTER_NAME' exists"
fi

echo "## Getting kubeconfig credentials"
az aks get-credentials --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --overwrite-existing --file $KUBECONFIG

yq e -i '.azure.kubeconfig = env(KUBECONFIG)' "$PARAMS_YAML"
