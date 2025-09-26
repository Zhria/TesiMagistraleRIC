set -euo pipefail

minikube delete;

REG_IP="${1:-192.168.17.70}"   # IP dell’host dove gira il registry
REG_PORT="${2:-5000}"          # Porta del registry
REG_NAME="registry"
REG_IMAGE="registry:2"

minikube start --insecure-registry="192.168.17.70:5000" --cni=calico --driver=docker --memory 2200
./ric-plt-ric-dep/bin/install_common_templates_to_helm.sh
./ric-plt-ric-dep/bin/install -f ./ric-plt-ric-dep/RECIPE_EXAMPLE/example_recipe_latest_stable.yaml;

echo "Aggiungo le IPTABLES per SCTP";

#sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222 \
#  || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222

#sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE \
#  || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE

#sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT \
#  || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
#sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT \
#  || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT

#./script.sh

#./abilitaPortForwarding.sh



# ========= 1) Verifica/avvio registry docker su questa macchina =========
if ! docker ps --format '{{.Names}}' | grep -q "^${REG_NAME}\$"; then
  echo "[i] Registry non in esecuzione. Lo avvio su ${REG_PORT}..."
  # se esiste container stoppato, lo rimuovo per evitare conflitti di port binding
  if docker ps -aq --format '{{.Names}}' | grep -q "^${REG_NAME}\$"; then
    docker rm -f "${REG_NAME}" >/dev/null 2>&1 || true
  fi
  docker run -d --restart=always --name "${REG_NAME}" -p "${REG_PORT}:5000" "${REG_IMAGE}"
else
  echo "[i] Registry già attivo."
fi

echo "[i] Check locale del catalogo:"
curl -s "http://127.0.0.1:${REG_PORT}/v2/_catalog" || true
echo
export CHART_REPO_URL="http://127.0.0.1:8090"
curl -s $CHART_REPO_URL/health

source ~/.venvs/dms/bin/activate


dms_cli onboard /home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/config-file.json /home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/schema.json
dms_cli install kpm-basic-xapp 1.0.0 ricxapp
kubectl get pods -n ricxapp
#kubectl logs -n ricxapp deploy/kpm-basic-xapp --tail=200
