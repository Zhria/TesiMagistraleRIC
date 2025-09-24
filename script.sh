ENS=ens18
MINIKUBE_IP=192.168.49.2

# Pulisci eventuali duplicati
sudo iptables -t nat -D PREROUTING -i $ENS -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination $MINIKUBE_IP:32222 2>/dev/null || true

# DNAT in PREROUTING (mettila PRIMA di tutto)
sudo iptables -t nat -I PREROUTING 1 -i $ENS -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination $MINIKUBE_IP:32222

# Consenti FORWARD in entrambe le direzioni
sudo iptables -C FORWARD -p sctp -d $MINIKUBE_IP --dport 32222 -j ACCEPT || sudo iptables -A FORWARD -p sctp -d $MINIKUBE_IP --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s $MINIKUBE_IP --sport 32222 -j ACCEPT || sudo iptables -A FORWARD -p sctp -s $MINIKUBE_IP --sport 32222 -j ACCEPT

# MASQUERADE (semplifica il ritorno)
sudo iptables -t nat -C POSTROUTING -p sctp -d $MINIKUBE_IP --dport 32222 -j MASQUERADE || sudo iptables -t nat -A POSTROUTING -p sctp -d $MINIKUBE_IP --dport 32222 -j MASQUERADE
