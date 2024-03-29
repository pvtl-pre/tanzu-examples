#!/bin/bash
set -e -o pipefail
shopt -s nocasematch;

TKG_LAB_SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$TKG_LAB_SCRIPTS/set-env.sh"

DELIVERABLES_DIR="generated/deliverables"
BUILD_CLUSTER_KUBECONFIG=$(yq e .clusters.build_cluster.k8s_info.kubeconfig $PARAMS_YAML)

information "Creating workload tanzu-java-web-app to the build cluster"

tanzu apps workload apply tanzu-java-web-app \
  --git-repo https://github.com/pvtl-pre/tanzu-java-web-app.git \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --label apps.tanzu.vmware.com/has-tests=true \
  --param-yaml testing_pipeline_matching_labels='{"apps.tanzu.vmware.com/language":"java", "apps.tanzu.vmware.com/pipeline":"test"}' \
  --namespace default \
  --yes \
  --kubeconfig $BUILD_CLUSTER_KUBECONFIG

information "Creating workload python-function to the build cluster"

tanzu apps workload apply python-function \
  --git-repo https://github.com/pvtl-pre/python-function.git \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=python-function \
  --label apps.tanzu.vmware.com/has-tests=true \
  --param-yaml testing_pipeline_matching_labels='{"apps.tanzu.vmware.com/language":"python", "apps.tanzu.vmware.com/pipeline":"test"}' \
  --namespace default \
  --build-env BP_FUNCTION=func.main \
  --yes \
  --kubeconfig $BUILD_CLUSTER_KUBECONFIG

information "Creating deliverable tanzu-java-web-app and python-function to the run clusters"

mkdir -p $DELIVERABLES_DIR

kubectl get deliverable tanzu-java-web-app -o yaml --kubeconfig $BUILD_CLUSTER_KUBECONFIG | kubectl neat >> $DELIVERABLES_DIR/tanzu-java-web-app.yaml
kubectl get deliverable python-function -o yaml --kubeconfig $BUILD_CLUSTER_KUBECONFIG | kubectl neat >> $DELIVERABLES_DIR/python-function.yaml

declare -a run_clusters=($(yq e -o=j -I=0 '.clusters.run_clusters[]' $PARAMS_YAML))

for ((i=0;i<${#run_clusters[@]};i++)); 
do
  RUN_CLUSTER_KUBECONFIG=$(yq e .clusters.run_clusters[$i].k8s_info.kubeconfig $PARAMS_YAML)

  kubectl apply -f $DELIVERABLES_DIR/tanzu-java-web-app.yaml --kubeconfig $RUN_CLUSTER_KUBECONFIG
  kubectl apply -f $DELIVERABLES_DIR/python-function.yaml --kubeconfig $RUN_CLUSTER_KUBECONFIG
done