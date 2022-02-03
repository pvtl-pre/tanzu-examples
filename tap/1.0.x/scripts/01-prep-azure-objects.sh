#!/bin/bash
set -e -o pipefail
shopt -s nocasematch;

TKG_LAB_SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$TKG_LAB_SCRIPTS/set-env.sh"

#
# Setup and preflight checks
#

# Get client id
AZURE_CREDENTIALS_CONFIGURED=false
export AZURE_CLIENT_ID=$(yq e .azure.client-id "$PARAMS_YAML")
# NOTE: yq returns null string...
if [ "$AZURE_CLIENT_ID" != "null" ]; then
  echo "INFO: client id already configured in $PARAMS_YAML, not setting up azure credentials"
  AZURE_CREDENTIALS_CONFIGURED=true
fi

# Ensure az is configured and working
if ! az account show > /dev/null; then
  echo "ERROR: could not run az account show, please configure az"
  exit 1
fi

RESOURCE_GROUP=$(yq e .azure.resource_group $PARAMS_YAML)
LOCATION=$(yq e .azure.location $PARAMS_YAML)

if [[ "$(az group exists --name $RESOURCE_GROUP)" == 'false' ]]; then
  echo "## Creating resource group '$RESOURCE_GROUP' in location '$LOCATION'"
  az group create --name $RESOURCE_GROUP --location $LOCATION
else
  echo "## Resource group '$RESOURCE_GROUP' exists"
fi