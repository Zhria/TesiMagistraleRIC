set -euo pipefail

minikube delete;

REG_PORT="${2:-5000}"          # Porta del registry
REG_NAME="registry"
REG_IMAGE="registry:2"

minikube start --cni=calico --driver=docker --memory 2200
./ric-plt-ric-dep/bin/install_common_templates_to_helm.sh
./ric-plt-ric-dep/bin/install -f ./ric-plt-ric-dep/RECIPE_EXAMPLE/example_recipe_latest_stable.yaml;

echo "Aggiungo le IPTABLES per SCTP";
sudo iptables-restore < ~/iptables.new

./restartXapps.sh

kubectl get pods -n ricxapp
#kubectl logs -n ricxapp deploy/kpm-basic-xapp --tail=200
