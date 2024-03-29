#!/bin/bash
set -e -o pipefail
shopt -s nocasematch;

TKG_LAB_SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$TKG_LAB_SCRIPTS/set-env.sh"

TAP_VERSION=$(yq e .tap_version $PARAMS_YAML)
INSTALL_REGISTRY_HOSTNAME=$(yq e .tanzu_registry.hostname $PARAMS_YAML)
INSTALL_REGISTRY_USERNAME=$(yq e .tanzu_registry.username $PARAMS_YAML)
INSTALL_REGISTRY_PASSWORD=$(yq e .tanzu_registry.password $PARAMS_YAML)

information "Creating tap-install and tap-gui namespaces"

kubectl create ns tap-install --dry-run=client -o yaml | kubectl --kubeconfig $KUBECONFIG apply -f -
kubectl create ns tap-gui --dry-run=client -o yaml | kubectl --kubeconfig $KUBECONFIG apply -f -

information "Adding image registry secret"

tanzu secret registry add tap-registry \
  --username $INSTALL_REGISTRY_USERNAME \
  --password $INSTALL_REGISTRY_PASSWORD \
  --server $INSTALL_REGISTRY_HOSTNAME \
  --export-to-all-namespaces \
  --yes \
  --namespace tap-install \
  --kubeconfig $KUBECONFIG

information "Adding the TAP package repository"

tanzu package repository add tanzu-tap-repository \
  --url $INSTALL_REGISTRY_HOSTNAME/tanzu-application-platform/tap-packages:$TAP_VERSION \
  --namespace tap-install \
  --wait=false \
  --kubeconfig $KUBECONFIG

information "Adding TAP GUI multi-cluster RBAC"

kubectl apply -f tap-declarative-yaml/tap-gui-viewer-service-account-rbac.yaml --kubeconfig $KUBECONFIG

if [[ $IS_VIEW_CLUSTER == false ]]; then
  information "Get service account token"

  SA_NAME=$(kubectl -n tap-gui get sa tap-gui-viewer -o yaml --kubeconfig $KUBECONFIG | yq -r '.secrets[0].name')
  export SA_TOKEN=$(kubectl -n tap-gui get secret $SA_NAME -o yaml --kubeconfig $KUBECONFIG | yq -r '.data["token"]' | base64 --decode)

  yq e -i "$SA_TOKEN_PATH = env(SA_TOKEN)" "$PARAMS_YAML"
fi

kubectl wait pkgr --for condition=ReconcileSucceeded=True \
  -n tap-install tanzu-tap-repository \
  --kubeconfig $KUBECONFIG \
  --timeout=5m
