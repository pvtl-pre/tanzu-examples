#!/bin/bash
set -e -o pipefail
shopt -s nocasematch;

TKG_LAB_SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$TKG_LAB_SCRIPTS/set-env.sh"

information "Setting up developer namespace on the build cluster"

BUILD_CLUSTER_KUBECONFIG=$(yq e .clusters.build_cluster.k8s_info.kubeconfig $PARAMS_YAML)

KUBECONFIG=$BUILD_CLUSTER_KUBECONFIG \
IS_BUILD_CLUSTER=true \
$TKG_LAB_SCRIPTS/tap-dev-namespace-base-install.sh

information "Setting up developer namespace on the run clusters"

declare -a run_clusters=($(yq e -o=j -I=0 '.clusters.run_clusters[]' $PARAMS_YAML))
  
for ((i=0;i<${#run_clusters[@]};i++)); 
do
  RUN_CLUSTER_KUBECONFIG=$(yq e .clusters.run_clusters[$i].k8s_info.kubeconfig $PARAMS_YAML)

  KUBECONFIG=$RUN_CLUSTER_KUBECONFIG \
  IS_BUILD_CLUSTER=false \
  $TKG_LAB_SCRIPTS/tap-dev-namespace-base-install.sh
done
