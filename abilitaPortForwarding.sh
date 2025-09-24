sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=2 
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2 # far vedere i pacchetti al filtro anche su bridge 
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-arptables=1 
sudo modprobe sctp nf_conntrack_sctp nf_nat nf_nat_sctp br_netfilter 
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp|br_netfilter)'
