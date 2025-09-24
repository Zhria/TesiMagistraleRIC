kubectl get svc -n ricplt 
kubectl describe svc service-ricplt-e2term-sctp-alpha -n ricplt
sudo iptables -C INPUT -p sctp --dport 32222 -j ACCEPT 2>/dev/null || sudo iptables -A INPUT -p sctp --dport 32222 -j ACCEPT
sudo apt-get install -y lksctp-tools
kubectl exec -it <e2term-pod-name> -n ricplt -- ss -lpn -A sctp | grep 36422
kubectl get pods -n ricplt -l 'app=ricplt-e2term-alpha,release=r4-e2term' -o wide --show-labels
ù
kubectl get pods -n ricplt -l 'app=ricplt-e2term-alpha,release=r4-e2term' -o wide --show-labels
kubectl get pods -n ricplt -l app=ricplt-e2term-alpha -o jsonpath='{range .items[*]}{.metadata.name}{"  "}{.metadata.labels}{"\n"}{end}'
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
kubectl get endpointslice -n ricplt | grep -i e2term
kubectl patch svc service-ricplt-e2term-sctp-alpha -n ricplt   -p '{"spec":{"selector":{"app":"ricplt-e2term-alpha"}}}'
kubectl patch svc service-ricplt-e2term-sctp-alpha -n ricplt -p '{"spec":{"selector":{"app":"ricplt-e2term-alpha"}}}'
kubectl get endpointslice -n ricplt | grep -i e2term
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
kubectl get deploy -n ricplt | grep -i e2term
kubectl get pods -n ricplt -l 'app=ricplt-e2term-alpha,release=r4-e2term' -o wide --show-labels
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
kubectl describe pod deployment-ricplt-e2term-alpha-f8f7d7855-m4cb7 -n ricplt
kubectl get events -n ricplt --sort-by=.lastTimestamp | tail -n 50
cd ../ric-plt-ric-dep/bin/
nano ver
nano versions.txt 
kubectl get deploy deployment-ricplt-e2term-alpha -n ricplt -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{" => "}{.image}{"\n"}{end}'
minikube image load nexus3.o-ran-sc.org:10002/o-ran-sc/ric-plt-e2:6.0.6
kubectl get deploy deployment-ricplt-e2term-alpha -n ricplt -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{" => "}{.image}{"\n"}{end}'
kubectl describe pod deployment-ricplt-e2term-alpha-f8f7d7855-m4cb7 -n ricplt
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
clear
kubectl get deploy -n ricplt | grep -i e2term deployment-ricplt-e2term-alpha
kubectl get deploy -n ricplt | grep -i e2term
kubectl get pods -n ricplt -l 'app=ricplt-e2term-alpha,release=r4-e2term'
kubectl describe pods
kubectl describe pods --all-namespaces
kubectl get pods -n ricplt -l 'app=ricplt-e2term-alpha,release=r4-e2term'
kubectl delete pod deployment-ricplt-e2term-alpha-f8f7d7855-m4cb7 -n ricplt
kubectl get pods -n ricplt
kubectl get svc -n ricplt
helm list -n ricplt
kubectl describe pod r4-e2term -n ricplt
kubectl describe pod r4-e2term 
kubectl get svc -n ricplt | grep -i e2
kubectl get svc -n ricplt
kubectl get svc -n ricplt | grep -i e2
sudo ss -lpn | grep 32222
sudo ss -lpn
sudo ss -lpn | grep 32222
sudo ss -lpn | grep 36422
sudo ss -lpn | grep 32222
kubectl get svc -n ricplt
kubectl get svc -n ricplt | grep -i e2
sudo modprobe sctp
sudo modprobe nf_conntrack_sctp
lsmod | egrep 'sctp|nf_conntrack_sctp'
sudo ss -lpn -A sctp | grep 32222
ip -4 addr
get pods
kubectl get pods
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
kubectl get deploy,ds,sts -n ricplt | grep -i e2term
df
kubectl get -n ricplt
lsblk -f
sudo fdisk -l
sudo vgs
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
df
cd installer/
# The version we download is the one indicated by ORAN SC in their RIC installation guides
wget https://get.helm.sh/helm-v3.11.2-linux-amd64.tar.gz 
tar xvzpf helm-v3.11.2-linux-amd64.tar.gz
sudo cp linux-amd64/helm /usr/local/bin/
rm -r /usr/local/bin/helm 
sudo rm -r /usr/local/bin/helm 
sudo cp linux-amd64/helm /usr/local/bin/
helm version
sudo apt update
sudo apt install tmux gcc-12 build-essential cmake autotools-dev automake libsctp-dev cmake-curses-gui libpcre2-dev jq -y
cd ../ric-plt-ric-dep/bin/
sudo ./install_common_templates_to_helm.sh 
eval $(minikube -p minikube docker-env)
ls
for i in `cat versions.txt`; do echo $i; docker pull $i; done
./install -f ../RECIPE_EXAMPLE/example_recipe_oran_j_release.yaml
minikube addons enable metrics-server
help repo
helm repo
helm repo list
kubectl get pods -n ricplt -l 'app=ricplt-e2term-alpha,release=r4-e2term' -w
kubectl describe pod <ne -n ricplt
kubectl describe pod deployment-ricplt-e2term-alpha-f8f7d7855-mpqws -n ricplt
kubectl get deploy deployment-ricplt-e2term-alpha -n ricplt   -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{" => "}{.image}{"\n"}{end}'
kubectl get secret -n ricplt | grep -i nexus
kubectl get svc kubernetes -n default -o wide
minikube status
minikube addons list | grep -E 'cni|calico'
minikube addons enable calico
minikube ssh -- "sudo systemctl restart kubelet"
kubectl get nodes
kubectl get deploy deployment-ricplt-e2term-alpha -n ricplt   -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{" => "}{.image}{"\n"}{end}'
kubectl describe pod deployment-ricplt-e2term-alpha-f8f7d7855-mpqws -n ricplt
kubectl get pods -n ricplt -l 'app=ricplt-e2term-alpha,release=r4-e2term' -w
clear
kubectl get pods -n ricplt -w | egrep 'e2term|NAME'
kubectl get pods -n ricplt -l app=ricplt-e2term-alpha -o wide
kubectl get deploy deployment-ricplt-e2term-alpha -n ricplt   -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{" => "}{.image}{"\n"}{end}'
kubectl get secret -n ricplt | grep -i nexus
kubectl create secret docker-registry secret-nexus3-o-ran-sc-org-10002-o-ran-sc   --docker-server=nexus3.o-ran-sc.org:10002  -n ricplt
kubectl create secret docker-registry secret-nexus3-o-ran-sc-org-10002-o-ran-sc   --docker-server=nexus3.o-ran-sc.org:10002   --docker-username='ztraka'   --docker-password='ztrakaTesi25*'   --docker-email='you@example.com'   -n ricplt
kubectl create secret docker-registry secret-nexus3-o-ran-sc-org-10002-o-ran-sc   --docker-server=nexus3.o-ran-sc.org:10002  -n ricplt
kubectl get secret -n ricplt | grep -i nexus
kubectl get deploy deployment-ricplt-e2term-alpha -n ricplt -o jsonpath='{.spec.template.spec.serviceAccountName}{"\n"}'
kubectl patch serviceaccount default -n ricplt   -p '{"imagePullSecrets":[{"name":"secret-nexus3-o-ran-sc-org-10002-o-ran-sc"}]}'
kubectl get pods -n ricplt -l app=ricplt-e2term-alpha -o wide
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
minikube stop
minikube start
minikube -p minikube docker-env
eval $(minikube -p minikube docker-env)
kubectl get pods -n ricplt -w | egrep 'e2term|NAME'
kubectl delete pod deployment-ricplt-e2term-alpha-f8f7d7855-mpqws -n ricplt
kubectl get pods -n ricplt -w | egrep 'e2term|NAME'
kubectl get event 
kubectl get events --all-namespaces  | grep -i deployment-ricplt-e2term-alpha-f8f7d7855-7sxpf 
kubectl -n kube-system get pods -o wide | egrep 'kube-proxy|calico|coredns'
minikube stop
minikube start --cni calico
kubectl -n kube-system get pods -o wide | egrep 'kube-proxy|calico|coredns'
kubectl -n kube-system get ep kubernetes
kubectl -n kube-system get
minikube addons enable calico
kubectl get svc kubernetes -o wide
kubectl -n kube-system get pods -o wide | egrep 'kube-proxy|calico|coredns'
minikube addons list | egrep 'cni|calico'
minikube addons list 
minikube start --cni=calico
watch kubectl get pods -l k8s-app=calico-node -A
kubectl get nodes
minikube delete
minikube start --cni=calico
kubectl get pods -n ricplt -l app=ricplt-e2term-alpha -o wide
./install 
./install -f ../RECIPE_EXAMPLE/example_recipe_oran_j_release.yaml 
ls
kubectl get pods -n ricplt -l app=ricplt-e2term-alpha -o wide
kubectl get events --all-namespaces  | grep -i deployment-ricplt-e2term-alpha-f8f7d7855-v4542
kubectl get pods -n ricplt -l app=ricplt-e2term-alpha -o wide
kubectl get svc service-ricplt-e2term-sctp-alpha -n ricplt
sudo modprobe sctp
sudo modprobe nf_conntrack_sctp
kubectl get pods -n ricplt -l app=ricplt-e2term-alpha -o wide
kubectl describe pod -n ricplt -l app=ricplt-e2term-alpha | egrep 'Ready|IP:|Containers:|Conditions'
kubectl get svc service-ricplt-e2term-sctp-alpha -n ricplt
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
kubectl describe pod -n ricplt -l app=ricplt-e2term-alpha | egrep 'Ready|IP:|Containers:|Conditions'
df
ls
minikube 
minikube start
ls
cd ric-plt-ric-dep/
ls
cd bin/
l
nano install
kubectl 
kubectl pods
kubectl pod
kubectl get
kubectl get pods
kubectl describe pods
ls
minikube kubectl get pods
minikube status
cat install
minikube stop
ls
cd ../..
ls
nano runMinikube.sh
chmod +x runMinikube.sh 
./runMinikube.sh 
nano runMinikube.sh
./runMinikube.sh 
kubectl get pods -n ricplt
kubectl get pods -n ricplt | grep e2
kubectl get pods -n ricplt | grep sctp
kubectl get pods -n ricplt | grep i sctp
kubectl get pods -n ricplt
kubectl get pods -n ricplt -l app=ricplt-e2term-alpha
kubectl get svc service-ricplt-e2term-sctp-alpha -n ricplt
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
minikube ip
sudo modprobe sctp
sudo modprobe nf_conntrack_sctp
ss -lt
ss -lt | grep 32222
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide
kubectl exec -n ricplt -it $(kubectl get pods -n ricplt -l app=ricplt-e2term-alpha -o jsonpath='{.items[0].metadata.name}') -- ss -lpn -A sctp | grep 36422
sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r)
sudo modprobe sctp
sudo modprobe nf_conntrack_sctp
lsmod | egrep 'sctp|nf_conntrack_sctp'
sudo modprobe nf_conntrack_sctp
uname -r
sudo apt-get install -y linux-modules-extra-virtual
uname -r                                  # deve stampare: 6.8.0-78-generic
sudo apt update
sudo apt install -y linux-modules-extra-$(uname -r)
sudo reboot
ls
cd ric-plt-ric-dep/
ls
cd RECIPE_EXAMPLE/
ls
history 
ls
./runMinikube.sh 
modprobe nf_conntrack
modprobe nf_conntrack_sctp
lsmod | grep sctp
sudo modprobe nf_conntrack_sctp
ss -lt
sudo modprobe nf_conntrack_sctp
uname -r
sudo apt install -y linux-modules-extra-6.8.0-79-generic
uname -r
dpkg -l | grep "linux-modules-extra-$(uname -r)"
modinfo nf_conntrack_sctp 2>/dev/null | head
modinfo nf_conntrack_sctp
sudo depmod -a
sudo apt update
sudo apt --reinstall install linux-modules-extra-$(uname -r)
sudo modprobe sctp
sudo modprobe nf_conntrack
sudo modprobe nf_conntrack_sctp
lsmod | egrep 'sctp|nf_conntrack'
echo -e "sctp\nnf_conntrack\nnf_conntrack_sctp" | sudo tee /etc/modules-load.d/sctp.conf
sudo modprobe nf_conntrack_sctp
zcat /proc/config.gz | grep NF_CONNTRACK_SCTP
uname -r
zcat /proc/config.gz | grep NF_CONNTRACK_SCTP
find /lib/modules/$(uname -r) -name 'nf_conntrack_sctp*.ko*'
sudo apt update
sudo apt install -y linux-image-generic linux-modules-extra-$(uname -r)
sudo reboot
sudo modprobe nf_conntrack_sctp
uname -r
dpkg -l | grep linux-image
dpkg -l | grep linux-modules
find /lib/modules/$(uname -r) -type f -name '*sctp*.ko*' | grep conntrack
zcat /proc/config.gz | grep NF_CONNTRACK_SCTP
grep -i sctp /proc/net/protocols
cat /proc/net/nf_conntrack | grep sctp
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide  # deve mostrare 10.244.120.76:36422
./runMinikube.sh 
nano r
nano runMinikube.sh 
./runMinikube.sh 
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide  # deve mostrare 10.244.120.76:36422
kubectl get pods -n ricplt -o wide
kubectl describe pod deployment-ricplt-e2term-alpha-f8f7d7855-ssr2q -n ricplt
kubectl get pvc pvc-ricplt-e2term-alpha -n ricplt
kubectl logs deployment-ricplt-e2term-alpha-f8f7d7855-ssr2q -n ricplt
kubectl exec -n ricplt deployment-ricplt-e2term-alpha-f8f7d7855-ssr2q -- cat /opt/e2/router.txt
kubectl exec -it -n ricplt deployment-ricplt-e2term-alpha-f8f7d7855-ssr2q -- /opt/e2/rmr_probe -h $(hostname -i):38000 -t 30
kubectl get svc -n ricplt | egrep 'e2term|rtmgr|submgr|rmr|prometheus'
kubectl get pods -n ricplt
kubectl get pods -n ricplt -o wide
kubectl get endpoints service-ricplt-e2term-sctp-alpha -n ricplt -o wide  # deve mostrare 10.244.120.76:36422
sctp_test
sctp_test -H localhost -P 4000 -h 192.168.17.70 -p 36422
sctp_test -H localhost -P 4000 -h 192.168.17.70 -p 36422 -s
sudo netstat -anp | grep sctp
ss -anp | grep sctp
kubectl exec -it -n ricplt deployment-ricplt-e2term-alpha-f8f7d7855-ssr2q --   ss -lnp -f inet_sctp | grep 36422
# dentro la VM minikube
minikube ssh
lsmod | grep sctp || sudo modprobe sctp
kubectl exec -it -n ricplt deployment-ricplt-e2term-alpha-f8f7d7855-ssr2q --   ss -lnp -f inet_sctp | grep 36422
# Endpoints SCTP (se il modulo SCTP è caricato)
kubectl exec -n ricplt deployment-ricplt-e2term-alpha-f8f7d7855-ssr2q --   /bin/sh -lc 'test -r /proc/net/sctp/eps && grep -w 36422 /proc/net/sctp/eps || echo "Nessun endpoint su 36422 o /proc/net/sctp/eps assente"'
kubectl rollout restart deploy/deployment-ricplt-e2term-alpha -n ricplt
kubectl get svc -n ricplt | grep -i e2term
minikube ssh
sudo modprobe sctp
sudo modprobe nf_conntrack_sctp
lsmod | grep -E 'sctp|nf_conntrack_sctp'   # verifica che compaiano
exit
kubectl -n ricplt rollout restart deploy/ricplt-e2term-alpha
kubectl -n ricplt rollout status deploy/ricplt-e2term-alpha
minikube status
kubectl rollout restart deploy/deployment-ricplt-e2term-alpha -n ricplt
kubectl rollout status deploy/deployment-ricplt-e2term-alpha -n ricplt
kubectl get svc -n ricplt | grep -i e2term
kubectl exec -it -n ricplt deployment-ricplt-e2term-alpha-f8f7d7855-ssr2q --   ss -lnp -f inet_sctp | grep 36422
kubectl get pods -n ricplt | grep e2term
kubectl get pods -n ricplt 
kubectl delete deployment-ricplt-e2term-alpha-64c4d584f7-njdvp -n ricplt
kubectl delete deployment-ricplt-e2term-alpha-64c4d584f7-njdvp
kubectl get pods -n ricplt 
minikube ssh
# carica i moduli subito
sudo modprobe sctp
sudo modprobe nf_conntrack_sctp
# rendili persistenti ai reboot della VM minikube
echo -e "sctp\nnf_conntrack_sctp" | sudo tee /etc/modules-load.d/sctp.conf
# verifica
lsmod | egrep '(^sctp|nf_conntrack_sctp)'
exit
ls
cd /tmp/
ls
cd /home/ztraka/ric-plt-ric-dep/
ls
cd bin/
ls
nano ricplt-role.yaml 
minikube ip
sudo sysctl -w net.ipv4.ip_forward=1
minikube ssh
kubectl -n ricplt patch deploy ricplt-e2term-alpha --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/hostNetwork","value":true},
  {"op":"add","path":"/spec/template/spec/dnsPolicy","value":"ClusterFirstWithHostNet"}
]'
kubectl -n ricplt rollout status deploy/ricplt-e2term-alpha
kubectl -n ricplt rollout status deploy/deployment-ricplt-e2term-alpha
kubectl -n ricplt patch deploy deployment-ricplt-e2term-alpha --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/hostNetwork","value":true},
  {"op":"add","path":"/spec/template/spec/dnsPolicy","value":"ClusterFirstWithHostNet"}
]'
kubectl -n ricplt rollout status deploy/deployment-ricplt-e2term-alpha
minikube ssh
kubectl -n ricplt patch deploy ricplt-e2term-alpha --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/hostNetwork","value":true},
  {"op":"add","path":"/spec/template/spec/dnsPolicy","value":"ClusterFirstWithHostNet"}
]'
kubectl -n ricplt patch deploy deployment-ricplt-e2term-alpha --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/hostNetwork","value":true},
  {"op":"add","path":"/spec/template/spec/dnsPolicy","value":"ClusterFirstWithHostNet"}
]'
iptables -t nat -vnL PREROUTING | grep 32222
sudo iptables -t nat -vnL PREROUTING | grep 32222
sudo iptables -t nat -vnL | grep 32222
minikube ssh
sudo iptables -t nat -vnL PREROUTING | grep 32222
sudo iptables -t nat -vnL FORWARD | grep 32222
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp)'
ip route get 192.168.49.2
kubectl -n ricplt patch deploy deployment-ricplt-e2term-alpha --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/hostNetwork","value":true},
  {"op":"add","path":"/spec/template/spec/dnsPolicy","value":"ClusterFirstWithHostNet"}
]'
kubectl -n ricplt rollout status deploy/deployment-ricplt-e2term-alpha
minikube ssh
uname
uname -r
sudo apt update
apt list -a linux-image-generic
sudo apt install linux-image-6.8.0-31-generic linux-headers-6.8.0-31-generic
dpkg --list | grep linux-image
grep menuentry /boot/grub/grub.cfg | grep 6.8
sudo grep menuentry /boot/grub/grub.cfg | grep 6.8
sudo grep menuentry /boot/grub/grub.cfg | grep 6.8.0-31
sudo nano /etc/default/grub
sudo grep menuentry /boot/grub/grub.cfg | grep 6.8
sudo grub-set-default "Advanced options for Ubuntu>Ubuntu, with Linux 6.8.0-31-generic"
sudo update-grub
uname -r
sudo reboot
ufw
helm -n ricplt list
kubectl -n $NS get svc | grep e2term
export $NS=ricplt
export $NS ricplt
kubectl -n $NS get svc | grep e2term
kubectl -n ricplt get svc | grep e2term
kubectl -n ricplt get svc service-ricplt-e2term-sctp-alpha -o yaml | egrep -A5 'ports:|protocol|port:|targetPort|nodePort'
minikube ssh
kubectl -n kube-system get pods -l k8s-app=kube-proxy
kubectl -n kube-system rollout restart ds/kube-proxy
kubectl -n kube-system get pods -l k8s-app=calico-node
uname -r
sudo apt-get update
minikube ssh
sudo tcpdump -i any -nn sctp port 32222 -vv
sudo apt install tcpdump
sudo tcpdump -i any -nn sctp port 32222 -vv
minikube
minikube ssh
kubectl -n kube-system logs -l k8s-app=kube-proxy --tail=200 | grep -i sctp
kubectl -n kube-system logs -l k8s-app=kube-proxy --tail=200 
sudo tcpdump -i any -nn sctp port 32222 -vv
kubectl get pods -n ricplt
kubectl port-forward
kubectl port-forward deployment-ricplt-e2term-alpha-544dc7876b-5mn5z   
kubectl port-forward deployment-ricplt-e2term-alpha-544dc7876b-5mn5
kubectl port-forward -h
nano runMinikube.sh 
kubectl get configmaps
kubectl get felixconfigurations.crd.projectcalico.org default -o yaml   | egrep -i 'bpfEnabled|bpfKubeProxyIptablesCleanupEnabled|bpfExternalServiceMode'
kubectl -n kube-system logs ds/calico-node -c calico-node --tail=200   | egrep -i 'BPF enabled|BPF data plane'
kubectl -n kube-system logs ds/calico-node -c calico-node --tail=200   | egrep -i 'BPF enabled|BPF data plane'
kubectl -n kube-system logs ds/calico-node -c calico-node --tail=200   | egrep -i 'BPF enabled|BPF data plane'
kubectl -n kube-system get ds kube-proxy
kubectl -n kube-system logs ds/kube-proxy --tail=200 | grep -i sctp
kubectl -n kube-system logs ds/kube-proxy --tail=200
kubectl -n kube-system get cm kube-proxy -o jsonpath='{.data.config\.conf}' | grep -i mode
sudo iptables -t nat -L KUBE-NODEPORTS -n -v | grep 32222
minikube ssh
sudo modprobe sctp nf_conntrack_sctp nf_nat || true
sudo modprobe nf_nat_sctp 2>/dev/null || true   # presente su alcune versioni
minikube ip
sudo iptables -t nat -A PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222   -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -A FORWARD -p sctp -d 192.168.49.2 --dport 32222 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222   -j MASQUERADE
sudo iptables -t nat -S | grep 32222
sudo tcpdump -i any -nn sctp port 32222 -vv
iptables
sudo iptables
sudo iptables -h
sudo iptables -t
sudo iptables -t defautl
sudo iptables -t default
sudo iptables -t filter
ping -c1 192.168.49.2 || echo "⚠️ minikube non risponde al ping"
ping -c1 192.168.49.2
ping 192.168.49.2
ip route get 192.168.49.2
ip neigh show 192.168.49.2
sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r)  # importantissimo su Ubuntu “minimal”
sudo modprobe sctp nf_conntrack_sctp nf_nat nf_nat_sctp
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp)'
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=2
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2
nano script.sh
chmod +x script.sh && ./script.sh
ip route
ifconfig
if
iwconfig
ip a
sudo iptables -t nat -vnL PREROUTING | grep 32222
sudo iptables -vnL FORWARD | grep 32222
./script.sh 
sudo iptables -vnL FORWARD | grep 32222
sudo iptables -t nat -vnL PREROUTING | grep 32222
sudo ufw status
sudo modprobe nf_log_ipv4
sudo sysctl -w net.netfilter.nf_log.2=nf_log_ipv4
sudo iptables -t raw -A PREROUTING -p sctp --dport 32222 -j TRACE
# Invia un solo tentativo dal client e osserva:
sudo dmesg -w | grep TRACE
# Poi rimuovi la regola TRACE
sudo iptables -t raw -D PREROUTING -p sctp --dport 32222 -j TRACE
history | grep tcp
sudo tcpdump -i any -nn sctp port 32222 -vv
sudo tcpdump -i any -nn sctp port 36422 -vv
uname -r
history | grep "apt install"
zgrep SCTP /proc/config.gz | grep CONNTRACK
find /lib/modules/$(uname -r) -name '*sctp*.ko*'
grep menuentry /boot/grub/grub.cfg
sudo grep menuentry /boot/grub/grub.cfg
sudo nano /boot/grub/grub.cfg 
sudo grub-set-default "Ubuntu, with Linux 6.8.0-31-generic"
sudo update-grub
sudo reboot
sudo grub-reboot "Advanced options for Ubuntu>Ubuntu, with Linux 6.8.0-31-generic"
sudo reboot
sudo grub-set-default "Advanced options for Ubuntu>Ubuntu, with Linux 6.8.0-31-generic"
sudo update-grub
history | grep "apt install"
sudo apt install -y linux-modules-extra-$(uname -r)
sudo modprobe nf_conntrack_sctp
cd /usr/include/linux/netfilter
ls
cat nf_conntrack_sctp.h 
lsmod | grep sctp
zgrep SCTP /proc/config.gz | grep NF_CT_PROTO
cd /proc/
ls
ls -l
zgrep SCTP /proc/config.gz | grep NF_CT_PROTO
grep NF_CT_PROTO_SCTP /boot/config-$(uname -r)
find /lib/modules/$(uname -r) -name '*sctp*.ko*'
cd /home/ztraka/
ls
./runMinikube.sh 
kubectl get pods -n ricplt
clear && kubeclt get pods -n ricplt
clear && kubectl get pods -n ricplt
clear && kubectl get endpoint -n ricplt
clear && kubectl get endpoints -n ricplt
clear && kubectl get svc -n ricplt
clear && kubectl get services -n ricplt
kubectl port-forward deploy/service-ricplt-e2term-sctp-alpha 32222:36422
kubectl port-forward deploy/deployment-service-ricplt-e2term-sctp-alpha 32222:36422
clear && kubectl config view
clear && kubectl config current-context
clear && kubectl get services -n ricplt
minikube service service-ricplt-e2term-sctp-alpha 
minikube service list
ping 192.168.49.2:32222
sctp_test -H 192.168.49.2 -P 32222 -h 127.0.0.1 -p 5555
sctp_test -H 192.168.49.2 -P 32222 -h 127.0.0.1 -p 5555 -s
sctp_test -p 192.168.49.2 -p 32222 -H 127.0.0.1 -H 5555 -s
sctp_test -h 192.168.49.2 -p 32222 -H 127.0.0.1 -P 5555 -s
history | grep tcpdump
sctp_test -H 192.168.49.2 -P 32222 -l 1
sctp_test -H 192.168.49.2 -P 32222 -l
sctp_test -H 192.168.17.70 -P 32222 -l
minikube ssh
sudo tcpdump -i any -nn sctp port 36422 -vv    # traffico verso il pod e2term
sudo tcpdump -i ens18 -nn sctp port 32222 -vv
sudo tcpdump -i br-a224777b7f1b -nn sctp port 32222 -vv   # cambia IF col tuo
ip a
sudo tcpdump -i br-0defdf22e833 -nn sctp port 32222 -vv   # cambia IF col tuo
pwd
ls
cd ric-plt-ric-dep/RECIPE_EXAMPLE/
ls
cd ../..
nano runMinikube.sh 
minikube ssh
sudo tcpdump -i any -nn sctp port 32222 -vv    # ingresso NodePort
sudo tcpdump -i ens18 -nn sctp port 32222 -vv
kubectl -n ricplt get svc service-ricplt-e2term-sctp-alpha -o yaml | egrep -A5 'ports:|protocol|nodePort|targetPort'
minikube ssh
minikube ssh -- sudo tcpdump -i any -nn sctp port 36422 -vv    # verso il pod e2term
sudo modprobe nf_log_ipv4
sudo iptables -t raw -I PREROUTING 1 -p sctp --dport 32222 -j TRACE
sudo journalctl -k -f | grep -i TRACE
sudo tee /etc/sysctl.d/99-ric-sctp.conf >/dev/null <<'EOF'
# Routing e RPF "loose"
net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=2
net.ipv4.conf.default.rp_filter=2
net.ipv4.conf.ens18.rp_filter=2

# Bridge → passa dai filtri iptables/arptables
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-arptables=1
EOF

# Applica subito
sudo sysctl --system
sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r) conntrack
sudo modprobe sctp nf_conntrack_sctp nf_nat nf_nat_sctp br_netfilter
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp|br_netfilter)'
# routing e RPF "loose"
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=2
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2
# far vedere i pacchetti al filtro anche su bridge
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-arptables=1
ENS=ens18
MINIKUBE_IP=192.168.49.2
# DNAT (ce l’hai già, ma la metto per completezza – in testa)
sudo iptables -t nat -C PREROUTING -i $ENS -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination $MINIKUBE_IP:32222   || sudo iptables -t nat -I PREROUTING 1 -i $ENS -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination $MINIKUBE_IP:32222
# MASQUERADE in uscita (semplifica il ritorno)
sudo iptables -t nat -C POSTROUTING -p sctp -d $MINIKUBE_IP --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d $MINIKUBE_IP --dport 32222 -j MASQUERADE
# FORWARD (tabella filter!)
sudo iptables -C FORWARD -p sctp -d $MINIKUBE_IP --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d $MINIKUBE_IP --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s $MINIKUBE_IP --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s $MINIKUBE_IP --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp)'
# se mancano:
sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r)
sudo modprobe sctp nf_conntrack_sctp nf_nat_sctp
sudo iptables -vnL FORWARD | egrep 'sctp|32222'
sudo sysctl -w net.ipv4.conf.all.rp_filter=2
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2
sudo sysctl -w net.ipv4.conf.br-a224777b7f1b.rp_filter=2
# e lascia i pacchetti passare dal filtro anche sui bridge
sudo modprobe br_netfilter
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-arptables=1
sudo conntrack -E -p sctp --dport 32222
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp)'
sudo modprobe sctp nf_conntrack_sctp nf_nat_sctp
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp)'
sudo modprobe sctp  nf_nat_sctp
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp)'
sudo modprobe nf_nat_sctp
# A) Verifica disponibilità del modulo
uname -r
modinfo nf_nat_sctp || echo "nf_nat_sctp non trovato"
# B) Installa i moduli extra del kernel (spesso sono qui)
sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r)
# C) Carica i moduli necessari
sudo modprobe sctp nf_conntrack_sctp nf_nat_sctp
# D) Controlla che ora ci siano
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp)'
sudo apt-get install -y linux-generic
grep CONFIG_NF_NAT_SCTP /boot/config-$(uname -r) || zcat /proc/config.gz | grep CONFIG_NF_NAT_SCTP
grep CONFIG_NF_NAT_SCTP /boot/config-$(uname -r) 
grep CONFIG_NF_NAT_SCTP /boot/config-6.8.0-31-generic 
grep CONFIG_NF_NAT_SCTP /boot/config-6.8.0-79-generic 
grep CONFIG_NF_NAT_SCTP /boot/config-6.8.0-78-generic 
grep CONFIG_NF_NAT_SCTP /boot/config-$(uname -r)
ls -1 /lib/modules/$(uname -r)/kernel/net/netfilter/nf_nat_sctp.ko* 2>/dev/null || echo "nf_nat_sctp.ko non trovato"
[ -d /sys/module/nf_nat_sctp ] && echo "nf_nat_sctp presente (built-in o modulo)"
grep CONFIG_NF_CONNTRACK_SCTP /boot/config-$(uname -r) 2>/dev/null || zgrep CONFIG_NF_CONNTRACK_SCTP /proc/config.gz
iptables -t nat -L
sudo iptables -t nat -L
iptables -L INPUT --line-numbers
sudo iptables -L INPUT --line-numbers
sudo iptables -L --line-numbers
sudo iptables -L -t nat --line-numbers
sudo iptables -t nat -L --line-numbers
iptables -D PREROUTING 1
sudo iptables -D PREROUTING 10
sudo sudo iptables -t nat -D PREROUTING 1
sudo sudo iptables -t nat -D POSTROUTING 3
ENS=ens18
MINIKUBE_IP=192.168.49.2
# DNAT (ce l’hai già, ma la metto per completezza – in testa)
sudo iptables -t nat -C PREROUTING -i $ENS -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination $MINIKUBE_IP:32222   || sudo iptables -t nat -I PREROUTING 1 -i $ENS -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination $MINIKUBE_IP:32222
# MASQUERADE in uscita (semplifica il ritorno)
sudo iptables -t nat -C POSTROUTING -p sctp -d $MINIKUBE_IP --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d $MINIKUBE_IP --dport 32222 -j MASQUERADE
# FORWARD (tabella filter!)
sudo iptables -C FORWARD -p sctp -d $MINIKUBE_IP --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d $MINIKUBE_IP --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s $MINIKUBE_IP --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s $MINIKUBE_IP --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -t nat -L --line-numbers
sudo iptables -t nat -D PREROUTING 1
sudo iptables -t nat -D POSTROUTING 3
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables 
sudo iptables -t
sudo iptables -L
sudo iptables -L --line-numbers
sudo sudo iptables -D FORWARD 1 2
sudo sudo iptables -D FORWARD 1
sudo sudo iptables -D FORWARD 2
sudo iptables -L 
sudo sudo iptables -t nat
sudo  iptables -t nat -L
sudo  iptables -t nat -D POSTROUTING 3
sudo  iptables -t nat -D PREROUTING 1
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo apt-get update
sudo apt-get install -y iptables-persistent  
sudo netfilter-persistent save     
sudo systemctl enable netfilter-persistent 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat 
sudo iptables -t nat -L
sudo iptables -t nat -D PREROUTING 1
sudo iptables -t nat -D POSTROUTING 3
sudo iptables -L 
sudo iptables -D FORWARD 1
sudo iptables -D FORWARD 2
sudo iptables -L
sudo iptables -D FORWARD 1
sudo iptables -A FORWARD DOCKER-FORWARD  all  --  anywhere             anywhere  
sudo systemctl restart docker
sudo iptables -L
ls
nano runMinikube.sh 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
ls
nano abilitaPortForwarding.sh
chmod +x abilitaPortForwarding.sh 
nano runMinikube.sh 
./abilitaPortForwarding.sh 
nano script.sh 
./script.sh 
sudo reboot
sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r) conntrack
sudo modprobe sctp nf_conntrack_sctp nf_nat nf_nat_sctp br_netfilter
# routing e RPF "loose"
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=2
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2
# far vedere i pacchetti al filtro anche su bridge
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-arptables=1
ENS=ens18
MINIKUBE_IP=192.168.49.2
# DNAT (ce l’hai già, ma la metto per completezza – in testa)
sudo iptables -t nat -C PREROUTING -i $ENS -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination $MINIKUBE_IP:32222   || sudo iptables -t nat -I PREROUTING 1 -i $ENS -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination $MINIKUBE_IP:32222
# MASQUERADE in uscita (semplifica il ritorno)
sudo iptables -t nat -C POSTROUTING -p sctp -d $MINIKUBE_IP --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d $MINIKUBE_IP --dport 32222 -j MASQUERADE
# FORWARD (tabella filter!)
sudo iptables -C FORWARD -p sctp -d $MINIKUBE_IP --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d $MINIKUBE_IP --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s $MINIKUBE_IP --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s $MINIKUBE_IP --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptable -t nat
sudo iptables -t nat
lsmod | egrep '(^sctp|nf_conntrack_sctp|nf_nat_sctp|br_netfilter)'
sudo journalctl -k -f | grep -i TRACE
history
history | grep "tcpdump"
sudo tcpdump -i ens18 -nn sctp port 32222 -vv
df
l
nano abilitaPortForwarding.sh 
./script.sh 
ls
nano runMinikube.sh 
ls
./runMinikube.sh 
ls
./abilitaPortForwarding.sh 
./script.sh 
ls
nano runMinikube.sh n
nano runMinikube.sh
./runMinikube.sh 
ls
chmod +x abilitaPortForwarding.sh 
ls -l
nano runMinikube.sh 
./runMinikube.sh 
history | grep "sudo tcpdump"
sudo tcpdump -i ens18 -nn sctp port 32222 -vv
sudo tcpdump -i any -nn sctp port 36422 -vv 
sudo tcpdump -i br-0defdf22e833 -nn sctp port 32222 -vv
ip route
sudo tcpdump -i br-562d84cbd8aa -nn sctp port 32222 -vv
ls
sudo iptables -t nat
sudo iptables -t nat -L 
sudo iptables -L 
l
nano runMinikube.sh 
sudo reboot
ls
sudo iptables -t nat -L
sudo iptables -t nat -D PREROUTING 1
sudo iptables -t nat -L
./runMinikube.sh 
sudo iptables -t nat
sudo iptables -t nat -L
sudo iptables -t nat -D PREROUTING 1
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -L
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -L
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -L
sudo iptables -t nat -D 1
sudo iptables -t nat -D PREROUTING 1
sudo iptables -t nat -L
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -L
sudo iptables -t nat -I POSTROUTING 1 -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -I FORWARD 1 -i ens18 -o br-562d84cbd8aa -p sctp -d 192.168.49.2 --dport 32222 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -i br-562d84cbd8aa -o ens18 -p sctp -s 192.168.49.2 --sport 32222 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -L
history
sudo tcpdump -i br-562d84cbd8aa -nn sctp port 32222 -vv
ip route
sudo tcpdump -nn sctp port 32222 -vv
ls
nano runMinikube.sh 
minikube status
sudo tcpdump -i any -nn sctp port 36422 -vv 
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222   -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -I POSTROUTING 1 -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222   -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222   -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I DOCKER-USER 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -I DOCKER-USER 1 -p sctp -s 192.168.49.2 --sport 32222   -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo netfilter-persistent save
sudo systemctl enable --now netfilter-persistent
sudo reboot
nano runMinikube.sh 
./runMinikube.sh 
nano runMinikube.sh 
./runMinikube.sh 
ls -l /etc/iptables/rules.v4 /etc/iptables/rules.v6
sudo iptables-restore --test /etc/iptables/rules.v4 && echo "rules.v4 OK"
sudo iptables -t nat -S | grep 32222
sudo iptables -S FORWARD | egrep 'sctp|32222'
sudo iptables -t nat -L
sudo iptables -L
history | grep "sudo tcpdump"
sudo tcpdump -nn sctp -vv
sudo tcpdump -i any -nn sctp -vv
logout 
./runMinikube.sh 
sudo tcpdump -i any -nn sctp -vv
sudo reboot
minikube ssh -- sudo tcpdump -i any -nn -vv sctp port 32222
minikube ssh -- sudo apt install tcpdump -y && sudo tcpdump -i any -nn -vv sctp port 32222
minikube ssh
# PULIZIA DNAT errate (se presenti)
sudo iptables -t nat -D PREROUTING -p sctp -d 172.17.0.1 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
# DNAT corretta (destinazione = IP host esterno)
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222   -j DNAT --to-destination 192.168.49.2:32222
# MASQUERADE verso minikube
sudo iptables -t nat -I POSTROUTING 1 -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
# FORWARD (mettile in TESTA, prima delle chain DOCKER)
sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222   -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222   -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=2
sudo sysctl -w net.ipv4.conf.default.rp_filter=2
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2
sudo modprobe br_netfilter
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
kubectl logs -n ricplt deploy/ricplt-e2term-alpha
kubeclt get pods -n ricplt
kubectl get pods -n ricplt
kubectl logs -n ricplt deploy/deployment-ricplt-e2term-alpha-f8f7d7855-6hzgh 
kubectl logs -n ricplt deployment-ricplt-e2term-alpha-f8f7d7855-6hzgh 
kubectl get pods -n ricplt
kubectl logs -n ricplt deployment-ricplt-e2mgr-9b6b8f99f-swd8c   
sudo tcpdump -i any -nn -vv sctp port 36422
minikube ssh
./runMinikube.sh 
kubectl get pods -n ricplt
sudo tcpdump -i any -nn sctp -vv
echo -e "sctp\nnf_conntrack_sctp\nnf_nat_sctp\nbr_netfilter" | sudo tee /etc/modules-load.d/ric-sctp.conf >/dev/null
sudo sysctl --system   # deve includere anche net.ipv4.ip_forward=1 ecc.
sudo tcpdump -i any -nn sctp -vv
kubectl get svc -n ricplt -o wide | egrep 'e2term|e2mgr|rtmgr'
kubectl logs -n ricplt deploy/ricplt-e2term-alpha --tail=200
kubectl logs -n ricplt deploy/deployment-ricplt-e2term-alpha --tail=200
kubectl logs -n ricplt deploy/ricplt-e2mgr --tail=200
kubectl logs -n ricplt deploy/deployment-ricplt-e2mgr --tail=200
kubectl get pods,svc,endpoints -n ricplt -o wide
kubectl logs -n ricplt deploy/deployment-ricplt-e2mgr --tail=200
kubectl logs -n ricplt deploy/deployment-ricplt-e2term-alpha --tail=200
kubectl -n ricplt set env deploy/deployment-ricplt-e2term-alpha E2TERM_LOG_LEVEL=DEBUG
kubectl rollout status -n ricplt deploy/deployment-ricplt-e2term-alpha
kubectl logs -n ricplt deploy/deployment-ricplt-e2term-alpha --tail=200
kubectl get pods -n rictpl
kubectl get pods -n ricplt
history
kubectl logs -n ricplt deploy/deployment-ricplt-e2term-alpha --tail=200
kubectl -n ricplt set env deployment/ricplt-e2term-alpha E2TERM_LOG_LEVEL=DEBUG
kubectl -n ricplt set env deployment-ricplt-e2term-alpha E2TERM_LOG_LEVEL=DEBUG
kubectl -n ricplt set env deploy/deployment-ricplt-e2term-alpha E2TERM_LOG_LEVEL=DEBUG
kubectl rollout status -n ricplt deploy/deployment-ricplt-e2term-alpha
kubectl logs -n ricplt deploy/ricplt-e2term-alpha -f | egrep -i 'e2ap|setup|asn|error'
kubectl logs -n ricplt deploy/deployment-ricplt-e2term-alpha -f | egrep -i 'e2ap|setup|asn|error'
kubectl exec -it -n ricplt deploy/deployment-ricplt-e2term-alpha --   tcpdump -i any -nn -s0 -vv -X port 36422
kubectl -n ricplt exec -it deploy/deployment-ricplt-e2term-alpha -- sh
kubectl -n ricplt get deploy deployment-ricplt-e2term-alpha   -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
history
sudo tcpdump -i any -nn sctp -vv
minikube status
kubectl -n ricplt get deploy deployment-ricplt-e2term-alpha   -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
kubectl -n ricplt get deploy deployment-ricplt-e2term-alpha -o yaml | grep -i version
kubectl -n ricplt exec deploy/deployment-ricplt-e2term-alpha -- env | egrep -i 'RIC|E2|VER|KPM'
kubectl -n ricplt get deploy deployment-ricplt-e2term-alpha   -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
kubectl -n ricplt exec deploy/deployment-ricplt-e2term-alpha --   sh -lc 'which strings >/dev/null 2>&1 && strings /usr/local/bin/e2term | egrep -i "E2AP|KPM|RIC|asn1|version" || echo "no strings"'
history | grep "tcpdump"
sudo tcpdump -i any -nn sctp -vv
sudo tcpdump -i any -nn sctp -vv
ls
minikube status
ls
ls
sudo iptables -t nat -L
ls
./runMinikube.sh 
nano runMinikube.sh 
./runMinikube.sh 
kubectl get pods -n ricplt
kubectl -n ricplt get deploy | grep -i e2term
kubectl -n ricplt get pods -l app=deployment-ricplt-e2term-alpha
kubectl --context nrrtric -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h
ls
sudo tcpdump -i any sctp -vv
minikube status
./runMinikube.sh 
sudo tcpdump -i any sctp -vv
history
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h | grep gnb
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h | grep {
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h
ls
./runMinikube.sh 
# elimina eventuali DNAT errate
sudo iptables -t nat -D PREROUTING -p sctp -d 172.17.0.1 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
# inserisci la DNAT corretta (deve stare in cima)
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo modprobe sctp nf_conntrack_sctp nf_nat_sctp br_netfilter 2>/dev/null || true
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=2
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo iptables -I OUTPUT 1 -p sctp -d 192.168.17.70 --dport 32222 -j ACCEPT
sudo iptables -I INPUT  1 -p sctp -s 192.168.17.70 --sport 32222 -j ACCEPT
ls
nano runMinikube.sh 
nano abilitaPortForwarding.sh 
sudo reboot
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h
history | grep DEBUG
kubectl -n ricplt set env deploy/deployment-ricplt-e2term-alpha E2TERM_LOG_LEVEL=TRACE
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h
kubectl -n ricplt t set env deploy/deployment-ricplt-e2term-alpha E2TERM_LOG_LEVEL=DEBUG
kubectl -n ricplt  set env deploy/deployment-ricplt-e2term-alpha E2TERM_LOG_LEVEL=DEBUG
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h
sudo tcpdump -i any sctp -vv
./runMinikube.sh 
./abilitaPortForwarding.sh 
sudo iproute -t nat -L && sudo iproute -L
sudo iptables -t nat -L && sudo iproute -L
sudo iptables -t nat -L && sudo iptables -L
nano runMinikube.sh 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
nano runMinikube.sh 
./runMinikube.sh 
history
nano runMinikube.sh 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
minikube ssh
sudo sysctl -w net.netfilter.nf_conntrack_sctp_timeout_established=86400
sudo sysctl -w net.netfilter.nf_conntrack_sctp_timeout_heartbeat=120
minikube ssh
ls
cd r
cd ric-plt-ric-dep/
ls
cd RECIPE_EXAMPLE/
ls
cd ../..
nano runMinikube.sh 
nano ric-plt-ric-dep/RECIPE_EXAMPLE/example_recipe_latest_stable.yaml 
cd ..
ls
cd home/ztraka/
l
./runMinikube.sh 
kubectl get pods -n ricplt
ls
cat ric-plt-ric-dep/RECIPE_EXAMPLE/example_recipe_latest_stable.yaml 
kubectl get pods -n ricplt
nano runMinikube.sh 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -t nat -L
sudo iptables -t nat -D PREROUTING -p sctp -d 172.17.0.1 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
nano runMinikube.sh 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
nano runMinikube.sh 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
./abilitaPortForwarding.sh 
sudo iptables -I DOCKER-USER 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -I DOCKER-USER 1 -p sctp -s 192.168.49.2 --sport 32222 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# Moduli per SCTP NAT/conntrack
sudo modprobe sctp
sudo modprobe nf_conntrack_sctp
sudo modprobe nf_nat_sctp 2>/dev/null || true
sudo modprobe br_netfilter
# Routing e RPF "loose"
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=2
sudo sysctl -w net.ipv4.conf.default.rp_filter=2
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo iptables -t nat -D PREROUTING -p sctp -d 172.17.0.1 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -D POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -t nat -I POSTROUTING 1 -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
minikube ssh
kubectl -n ricplt get pods | grep e2term
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc bash
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc sh
minikube ssh
pgre -fa e2term
pgrep -fa e2term
sudo tshark -i any -nn -f "sctp" -Y "sctp.chunk_type==6" -O sctp
sudo apt install tshark
sudo tshark -i any -nn -f "sctp" -Y "sctp.chunk_type==6" -O sctp
kubectl -n ricplt get pods | grep e2term
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc -- sh -lc 'ps -eo pid,comm | grep -i e2'
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc -- sh 
ls
strace
sudo apt install strace
strace -f -tt -s 128 -e trace=epoll_wait,recvmsg,sendmsg,getsockopt -p 23
sudo strace -f -tt -s 128 -e trace=epoll_wait,recvmsg,sendmsg,getsockopt -p 23
ls
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc -- sh -lc "ss -tpi 'sport = 32222 or dport = 32222'"
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc sh 
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc sh
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc -- sh
ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX REM_ADDR_RTX START STATE
10.244.120.64  45 1 1000 5 0 0 2
192.168.17.94  45 1 3000 5 0 0 3
192.168.10.1  45 1 3000 5 0 0 3
10.100.200.1  45 1 3000 5 0 0 3
172.18.0.1  45 1 3000 5 0 0 3
192.168.70.129  45 1 3000 5 0 0 3
172.17.0.1  45 1 3000 5 0 0 3 
# grep -E 'Abort|Proto|Invalid|Cookie' /proc/net/sctp/snmp
SctpAborteds                    	8
SctpT1CookieExpireds            	0
kubectl -n ricplt get pods | grep -i e2term
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc -- sh -lc 'ps -eo pid,comm,args | grep -i e2term'
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc -- sh -lc 'ps -eo pid,comm,args | grep -i e2
kubectl -n ricplt exec -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc -- sh -lc 'ps -eo pid,comm,args | grep -i e2'
kubectl -n ricplt debug -it deployment-ricplt-e2term-alpha-f8f7d7855-fq4tc   --image=debian:bookworm-slim   --target=container-ricplt-e2term -- bash
sudo tcpdump -i any sctp
sudo tcpdump -i any sctp -vv
pwd
kubectl -n ricplt set env deploy/deployment-ricplt-e2term-alpha MDCLOG_LEVEL=DEBUG
kubectl -n ricplt set env deploy/deployment-ricplt-e2term-alpha RMR_VLEVEL=5 RMR_VCTL=/tmp/rmr.v
kubectl -n ricplt rollout restart deploy/deployment-ricplt-e2term-alpha
kubectl -n ricplt logs -f deploy/ricplt-e2term-alpha --all-containers=true
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2term-alpha --all-containers=true
history
kubectl -n ricplt logs deploy/deployment-ricplt-e2term-alpha -f --since=1h
kubectl -n ricplt set env deploy/deployment-ricplt-e2mgr MDCLOG_LEVEL=DEBUG
kubectl -n ricplt set env deploy/deployment-ricplt-e2mgr RMR_VLEVEL=5
kubectl -n ricplt rollout restart deploy/deployment-ricplt-e2mgr
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2mgr
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2mgr | grep "1080 Failed SCTP Connection"
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2mgr | grep "Failed SCTP Connection"
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2mgr | grep "Failed SCTP"
sudo sysctl -w net.sctp.addip_enable=0
# (opzionale ma utile per debug)
sudo sysctl -w net.sctp.ps_retrans=0
sudo iptables -I INPUT  -p sctp ! -d 192.168.17.70 --dport 32222 -j DROP
sudo iptables -I OUTPUT -p sctp ! -s 192.168.17.70 --sport 32222 -j DROP
sudo sysctl -w net.sctp.addip_enable=0
sudo iptables -I OUTPUT -p sctp -d 192.168.17.70 -j ACCEPT
sudo iptables -I OUTPUT -p sctp ! -d 192.168.17.70 -j DROP
sudo sysctl -w net.sctp.addip_enable=0
sudo sysctl -w net.sctp.auto_asconf=0
sudo iptables -t nat -L
sudo iptables -L
sudo iptables -D OUTPUT 1
sudo iptables -D INPUT 1
sudo iptables -I INPUT  -p sctp -d 192.168.17.70 --dport 32222 -j ACCEPT
sudo iptables -A INPUT  -p sctp --dport 32222 -j DROP
sudo iptables -A INPUT  -p sctp -j DROP
ls
nano ric-plt-ric-dep/RECIPE_EXAMPLE/example_recipe_latest_stable.yaml 
nano runMinikube.sh 
./runMinikube.sh 
sudo ss -A sctp -lpn | grep 1987 || true
sudo ss -A sctp -pn  | grep 1987 || true
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2mgr
kubectl create ns ricxapp 2>/dev/null || true
helm upgrade --install my-xapp ./my-xapp -n ricxapp   --set image.repository=<registry>/my-xapp   --set image.tag=0.1.0
kubectl get pods -n ricxapp -w
helm upgrade --install kpm_app ./kpm_basic_xapp/ -n ricxapp   --set image.repository=localhost:5000/my-xapp   --set image.tag=0.1.0
helm upgrade --install kpm_basic_app ./kpm_basic_xapp/ -n ricxapp   --set image.repository=localhost:5000/my-xapp   --set image.tag=0.1.0
ls
cd ..
ls
cd xDevSM-xapps-examples/
cd appmgr/
ls
cd xapp_orchestrater/dev/xapp_onboarder/
ls
pip3 install ./
cd ..
rm -r appmgr/
sudo rm -r appmgr/
git clone https://gerrit.o-ran-sc.org/r/it/dep
ls
cd dep/
git submodule update --init --recursive --remote
cd ..
ls 
cd ..
ls
cd ric-plt-ric-dep/
ls
cd ../xDevSM-xapps-examples/dep/
ls
cd RE
cd RECIPE_EXAMPLE/
cat ../README.md 
./runMinikube.sh 
kubectl get pods -n ricplt
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2mgr
kubectl -n ricplt exec -it deploy/deployment-ricplt-e2term-alpha -- bash -lc '
  command -v tcpdump >/dev/null || apt-get update && apt-get install -y tcpdump;
  tcpdump -i any -s0 -vvv -w /tmp/e2-abort.pcap sctp port 36422
'
kubectl -n ricplt exec -it deploy/deployment-ricplt-e2term-alpha -- bash -lc '
  command -v tcpdump >/dev/null || apt-get update && apt-get install -y tcpdump;
  tcpdump -i any -s0 -vvv -w /tmp/e2-abort.pcap sctp port 36422
'
kubectl -n ricplt exec -it deploy/deployment-ricplt-e2term-alpha -- bash -lc '
  command -v tcpdump >/dev/null || apt-get update && apt-get install -y tcpdump;
  tcpdump -i any -s0 -vvv -w /tmp/e2-abort2.pcap sctp port 36422
'
kubectl -n ricplt cp deploy/deployment-ricplt-e2term-alpha:/tmp/e2-abort2.pcap ./e2-abort.pcap
cp
kubectl -n ricplt cp
POD=$(kubectl -n ricplt get pods -l app=ricplt-e2term-alpha -o jsonpath='{.items[0].metadata.name}')
POD=$(kubectl -n ricplt get pods -l app=ricplt-e2term-alpha -o jsonpath='{.items[0].metadata.name}');
kubectl -n ricplt get pods -l app=ricplt-e2term-alpha -o jsonpath='{.items[0].metadata.name}
kubectl -n ricplt get pods -l app=ricplt-e2term-alpha -o jsonpath='{.items[0].metadata.name}'
kubectl -n ricplt cp deployment-ricplt-e2term-alpha-f8f7d7855-dr58c
kubectl -n ricplt cp deployment-ricplt-e2term-alpha-f8f7d7855-dr58c:/tmp/e2-abort2.pcal ./e2-abort.pcap
kubectl -n ricplt cp deployment-ricplt-e2term-alpha-f8f7d7855-dr58c:/tmp/e2-abort2.pcap ./e2-abort.pcap
kubectl -n ricplt cp deployment-ricplt-e2term-alpha-f8f7d7855-dr58c:/tmp/e2-abort2.pcap ./e2-abort.pcap -c container-ricplt-e2term
ls
tshark -r ./e2-abort.pcap -Y "sctp.chunk_type==3" -V | head -n 100
tshark -r ./e2-abort.pcap -Y "sctp.chunk_type==3" -V | head -n 100 | grep ABORT
tshark -r ./e2-abort.pcap -Y "sctp.chunk_type==3" -V 
tshark -r ./e2-abort.pcap -Y "sctp.chunk_type in {6,7,8,9}" -V 
tshark -r ./e2-abort.pcap  -V 
kubectl get pods -n ricplt
kubectl get pods -n ricxapp
ls
cd xDevSM-xapps-examples/
ls
cd kpm_basic_xapp/
ls
cat Re
cat README.md 
ls
cat kpm_xapp.py 
ls
cd config/
ls
cd ,,
c d..
cd ..
,s
ls
cat setup_imports.py 
ls
nano Dockerfile
docker build -t localhost:5000/kpm_app:0.1.0 .
gcc
pip install --upgrade pip
history | grep venv
ls
cat requirements.txt 
docker build -t localhost:5000/kpm_app:0.1.0 .
nano Dockerfile 
docker build -t localhost:5000/kpm_app:0.1.0 .
docker push localhost:5000/kpm_app:0.1.0
ls
nano Dockerfile 
docker build -t localhost:5000/kpm_app:0.1.0 .
ls
cd ..
ls
cd docker/
ls
cd ..
docker build -t localhost:5000/kpm_app:0.1.0 docker/Dockerfile.kpm_basic_xapp .
docker build -t localhost:5000/kpm_app:0.1.0 -f docker/Dockerfile.kpm_basic_xapp .
kubectl -n ricplt cp deploy/deployment-ricplt-e2term-alpha:/tmp/e2-abort2.pcap ./e2-abort.pcap
kubectl get pods -n ricplt
kubectl -n ricplt cp deploy/deployment-ricplt-e2term-alpha-f8f7d7855-dr58c:/tmp/e2-abort2.pcap ./e2-abort.pcap
kubectl -n ricplt cp deployment-ricplt-e2term-alpha-f8f7d7855-dr58c:/tmp/e2-abort2.pcap ./e2-abort.pcap
kubectl -n ricplt exec -it deplo/deployment -- bash
kubectl -n ricplt exec -it deploy/deployment-ricplt-e2term-alpha -- bash
docker run -d -p 5000:5000 --restart always --name registry registry:3
$ docker pull ubuntu
docker tag ubuntu localhost:5000/ubuntu
docker push localhost:5000/ubuntu
cd ..
ls
cd ztraka/
ls
cd xDevSM-xapps-examples/
ls
cd kpm_basic_xapp/
sl
l
cd config/
ls
cat config-file.json 
nano config-file.json 
cd ..
ls
nano config-file.json 
cd config/config-file.json 
nano config/config-file.json 
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2term
kubectl -n ircplt
kubectl -n ricplt
kubectl get pods-n ricplt
kubectl get pods -n ricplt
kubectl -n ricplt logs -f deploy/deployment-ricplt-e2term-alpha-f8f7d7855-dr58c
kubectl -n ricplt logs -f deployment-ricplt-e2term-alpha-f8f7d7855-dr58c
curl -v http://localhost:32080/appmgr/ric/v1/health/ready
pwd
cd ..
ls
ls -l
ls -l grep |.
source venv/bin/activate
ls
cd xDevSM-xapps-examples/
ls
source venv/bin/activate
source /bin/activate
source ./python_env/bin/activate
ls -l
cd ..
ls
virtualenv 
pip install
python3 -m venv .
source .venv/bin/activate
source .bin/activate
ls
source /bin/activate
lls
ls
pwd
source ./bin/activate
ls
cd xDevSM-xapps-examples/
ls
cd xDevSM/
ls
cd ..
ls dep
ls
cd dep
ls
cat README.md 
ls
cd ..
sudo rm -r dep/
git clone "https://gerrit.o-ran-sc.org/r/ric-plt/appmgr"
cd appmgr/xapp_orchestrater/dev/xapp_onboarder/
ls
pip3 install ./
dms_cli onboard --config_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/config-file.json --schema_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/schema.json 
pip3 install urllib3
dms_cli onboard --config_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/config-file.json --schema_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/schema.json 
whereis dms_cli
python3 -m venv ~/.venvs/dms
source ~/.venvs/dms/bin/activate
python -m pip install --upgrade pip
pip uninstall -y urllib3
pip install "urllib3<2" six requests
ls
pip install ./
python -c "import urllib3, six; import urllib3.packages.six as s; print('ok', urllib3.__version__)"
which dms_cli
~/.venvs/dms/bin/python -c "import urllib3; print(urllib3.__version__)"
pip uninstall -y urllib3
pip install "urllib3<2" six requests
pip install urllib3==1.25.8
dms_cli onboard --config_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/config-file.json --schema_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/schema.json 
pip uninstall -y dms-cli xapp-onboarder urllib3 requests six
pip install "urllib3==1.26.18" "requests==2.31.0" "six==1.16.0"
pip install --no-deps .
python - <<'PY'
import sys, urllib3
print("python:", sys.version)
print("urllib3:", urllib3.__version__)
from urllib3.packages.six.moves import http_client
print("ok: urllib3.packages.six.moves disponibile")
PY

dms_cli onboard --config_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/config-file.json --schema_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/schema.json 
dms_cli onboard --config_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/config-file.json --shcema_file_path=/home/ztraka/xDevSM-xapps-examples/kpm_basic_xapp/config/schema.json 
cd ..
lks
ls
cd kpm_basic_xapp/config/
ls
dms_cli onboard . .
dms_cli onboard config-file.json schema.json 
kubectl get svc -n ricplt
minikube ip
docker run --rm -u 0 -it -d -p 8090:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
export CHART_REPO_URL=http://0.0.0.0:8090
dms_cli onboard config-file.json schema.json 
sudo docker ps
sudo docker stop 18b2b0101bdc
curl -s http://127.0.0.1:8090/api/charts | jq .
curl http://127.0.0.1:8090/health
curl http://127.0.0.1:8090/api/charts
curl http://127.0.0.1:8090/health
curl http://127.0.0.1:8090/api/charts
lkogout
logout
cat /proc/loadavg
sudo apt install htop
htop
ps aux --sort=-rss | head -n 20
rm -rf ~/.vscode-server/extensions/ms-python.python*
cd .vscode-server/
ls
cd extensions/
ls
rm -rf ~/.vscode-server/extensions/ms-python
rm -rf ~/.vscode-server/extensions/ms-python*
ls
ls
git
wpd
pwd
ls
cd xDevSM-xapps-examples/
ls
cd kpm_basic_xapp/config/
dms_cli onboard config-file.json schema.json 
source ~/.venvs/dms/bin/activate
nano attivaEnv.sh
chmod +x attivaEnv.sh 
mv attivaEnv.sh ../../
cd ../..
ls
mv attivaEnv.sh ..
cd kpm_basic_xapp/config/
dms_cli onboard config-file.json schema.json 
sudo docker ps
docker run --rm -u 0 -it -d -p 8090:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
dms_cli onboard config-file.json schema.json 
docker run --rm -u 0 -it -d -p 8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
dms_cli onboard config-file.json schema.json 
kubectl get svc -n ricplt | grep -E 'appmgr|onbrd|chart'
curl http://localhost:8080/api/charts
curl http://127.0.0.0:8080/api/charts
export CHART_REPO_URL="http://127.0.0.1:8090"
dms_cli onboard config-file.json schema.json 
dms_cli install kpm-basic-app 1.0.0 ricxapp
dms_cli install kpm-basic-xapp 1.0.0 ricxapp
ls
history
ssh
free
free -m
ps aux
kill 4054521
ps aux
ps aux | sort
free -m
htop
minikube status
kubectl
kubectl get pods 
kubectl get pod -n ricplt
ls
./runMinikube.sh 
nano runMinikube.sh 
ls
sudo tcpdump -i any sctp 
sudo tcpdump -i any sctp -vv
export CHART_REPO_URL="http://127.0.0.1:8090"
curl -s $CHART_REPO_URL/health
l
./attivaEnv.sh 
pip
./attivaEnv.sh 
nano attivaEnv.sh 
dms_cli onboard xDevSM-xapps-examples/kpm_basic_xapp/config/config-file.json  xDevSM-xapps-examples/kpm_basic_xapp/config/schema.json 
nano attivaEnv.sh 
source ~/.venvs/dms/bin/activate
dms_cli onboard xDevSM-xapps-examples/kpm_basic_xapp/config/config-file.json  xDevSM-xapps-examples/kpm_basic_xapp/config/schema.json 
dms_cli install kpm-basic-xapp 1.0.0 ricxapp
kubectl get pods -n ricxapp
kubectl logs -n ricxapp deploy/kpm-basic-xapp --tail=200
ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r
kubectl logs -n ricxapp ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r --tail=200
kubectl get pods -n ricxapp
kubectl logs deploy/ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r 
kubectl logs deploy/deployment-ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r 
kubectl logs -n ricxapp deploy/kpm-basic-xapp --tail=200ù
kubectl logs -n ricxapp deploy/ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r --tail=20
kubectl logs -n ricxapp ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r --tail=20
(dms) ztraka@nrrtric:~$ kubectl get pods -n ricxapp
NAME                                      READY   STATUS 
kubectl -n ricxapp get deploy kpm-basic-xapp -o=jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
kubectl -n ricxapp describe pod ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r | sed -n '/Events/,$p'
sudo docker ps
docker run -d -p 5000:5000 --name registry registry:2.7
docker run 490b415234e80abc7ebd5bf2d74e450fcc14324a00c6334339114a62245e937b
sudo docker ps | grep registry
kubectl -n ricxapp describe pod ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r 
minikube ssh -- curl -s http://192.168.17.70:5000/v2/_catalog
minikube ssh
sudo mkdir -p /etc/containerd/certs.d/192.168.17.70:5000
sudo tee /etc/containerd/certs.d/192.168.17.70:5000/hosts.toml >/dev/null <<'EOF'
server = "http://192.168.17.70:5000"
[host."http://192.168.17.70:5000"]
  capabilities = ["pull", "resolve"]
EOF

sudo systemctl restart containerd
exit
ls
nano script.sh 
./script.sh 
nano runMinikube.sh 
minikube image load localhost:5000/kpm_app:0.1.0
sudo docker ps
sudo docker stop 1509d1579638
sudo docker ps
ls
history 
history  | grep "helm"
ls
helm uninstall kpm-basic-app
helm uninstall kpm-basic-app -n ricxapp
helm uninstall kpm-basic-xapp -n ricxapp
kubectl -n ricxapp describe pod ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r 
ls
./attivaEnv.sh 
nano attivaEnv.sh 
sudo systemctl restart containerd
nano attivaEnv.sh 
source ~/.venvs/dms/bin/activate
ls
kubectl get pods -n ricxapp
kubectl rollout restart ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r 
kubectl rollout restart deployment ricxapp-kpm-basic-xapp-796b98cc6f-nmn8r 
kubectl rollout restart deployment ricxapp-kpm-basic-xapp
kubectl rollout restart deployment kpm-basic-xapp
kubectl -n ricxapp rollout restart deploy kpm-basic-xapp
kubectl -n ricxapp describe pols
[200~dms_cli download_helm_chart kpm-basic-xapp 0.1.0 # change name and version accordingly
~
nano attivaEnv.sh 
source ~/.venvs/dms/bin/activate
dms_cli download_helm_chart kpm-basic-xapp 0.1.0
minikube status
dms_cli download_helm_chart kpm-basic-xapp 0.1.0
export CHART_REPO_URL=http://0.0.0.0:8090
dms_cli download_helm_chart kpm-basic-xapp 0.1.0
dms_cli download_helm_chart kpm-basic-xapp
dms_cli download_helm_chart kpm-basic-xapp 0.1.0
ls
cd xDevSM-xapps-examples/kpm_basic_xapp/config/
dms_cli onboard config-file.json schema.json 
ls
nano c
nano config-file.json 
dms_cli onboard config-file.json schema.json 
dms_cli download_helm_chart kpm-basic-xapp 0.1.0
dms_cli -h
dms_cli get_chart_lists
dms_cli get_chart_list
dms_cli -h
dms_cli get_charts_list
dms_cli download_helm_chart kpm-basic-xapp 1.0.0
ls
helm install kpm-basic-xapp kpm-basic-xapp-1.0.0.tgz -n ricxapp
history
helm uninstall kpm-basic-xapp -n ricxapp
helm install kpm-basic-xapp kpm-basic-xapp-1.0.0.tgz -n ricxapp
kubectl get pods -n ricxapp
kubectl get pods -n ricxapp -f
kubectl get pods -n ricxapp -t
kubectl get pods -n ricxapp -w
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-2hvb2 -n ricxapp
l
cd ..
ls
cd ..
ls
helm install kpm-basic-xapp kpm-basic-xapp-0.2.0-dev.tgz -n ricxapp
history | grep "docker build"
ls
cd docker/
cd ..
history | grep "docker"
docker push localhost:5000/kpm_app:0.1.0
ls
cd ..
ls
nano attivaEnv.sh 
source ~/.venvs/dms/bin/activate
cd xDevSM-xapps-examples/
ls
dms_cli onboard ./kpm_basic_xapp/config/config-file.json ./kpm_basic_xapp/config/schema.json 
history | grep EXPORT
history | grep export
dms_cli onboard ./kpm_basic_xapp/config/config-file.json ./kpm_basic_xapp/config/schema.json 
ls
history | grep "dms_cli install" 
kubect get pods -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-4pgxn  -n ricxapp
docker run -i -t kpm-basic-xapp
docker run -i -t kpm-basic-xapp:0.1.0
docker images
docker run -i -t localhost:5000/kpm_app 
docker run kpm_app:0.1.0
docker run 2e31379154b7:0.1.0
sudo docker run 2e31379154b7:0.1.0
sudo docker run localhost:5000/kpm_app
docker run --rm -it -p 8080:8080 localhost:5000/kpm_app:0.1.0
docker run -i -t localhost:5000/kpm_app docker build -t localhost:5000/kpm_app:0.1.0 -f docker/Dockerfile.kpm_basic_xapp .
docker build -t localhost:5000/kpm_app:0.1.0 -f docker/Dockerfile.kpm_basic_xapp .
docker run -i -t localhost:5000/kpm_app docker build -t localhost:5000/kpm_app:0.1.0 -f docker/Dockerfile.kpm_basic_xapp .
docker run -i -t localhost:5000/kpm_app
docker run --rm -it -p 8080:8080 localhost:5000/kpm_app:0.1.0
docker registry
docker images
docker image prune -f
docker images
docker rmi 192.168.17.70:5000/kpm_app:0.1.0
docker images
docker rmi 192.168.17.70/kpm_app:0.1.0
docker images
helm uninstall kpm-basic-xapp -n ricxapp
dms_cli onboard ./kpm_basic_xapp/config/config-file.json ./kpm_basic_xapp/config/schema.json 
dms_cli install kpm-basic-xapp 1.0.0
history | grep install
dms_cli install kpm-basic-xapp 1.0.0 ricxapp
sudo rm -r /tmp/helm_template/kpm-basic-xapp
dms_cli install kpm-basic-xapp 1.0.0 ricxapp
helm uninstall kpm-basic-xapp -n ricxapp
dms_cli install kpm-basic-xapp 1.0.0 ricxapp
helm uninstall kpm-basic-xapp -n ricxapp
sudo rm -r /tmp/helm_template/kpm-basic-xapp
dms_cli install kpm-basic-xapp 1.0.0 ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-hgtpr
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-hgtpr -n ricxapp
docker images
docker run --rm -it -p 8080:8080 localhost:5000/kpm_app:0.1.0
docker build -f docker/Dockerfile.kpm_basic_xapp -t 192.168.17.70:5000/kpm_app:0.1.0 .
docker push 192.168.17.70:5000/kpm_app:0.1.0
docker push localhost:5000/kpm_app:0.1.0
docker images
kubectl -n ricxapp patch deploy kpm-basic-xapp --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/workingDir","value":"/app"}]'
helm uninstall kpm-basic-xapp 1.0.0 -n ricxapp
dms_cli onboard ./kpm_basic_xapp/config/config-file.json ./kpm_basic_xapp/config/schema.json 
dms_cli install kpm-basic-xapp 1.0.0 -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-7ccm9
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-7ccm9 -n ricxapp
kubectl -n ricxapp patch deploy kpm-basic-xapp --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/workingDir","value":"/app"}]'
kubectl -n ricxapp patch deploy ricxapp-kpm-basic-xapp-597c5c7497-7ccm9 --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/workingDir","value":"/app"}]'
kubectl -n ricxapp patch deploy deployment-ricxapp-kpm-basic-xapp-597c5c7497-7ccm9 --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/workingDir","value":"/app"}]'
kubectl -n ricxapp patch deploy kpm-basic-xapp --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/workingDir","value":"/app"}]'
kubectl -n ricxapp patch deploy kpm-basic-xapp --type=json   -p='[{"op":"add","path":"/spec/template/spec/cont
kubectl -n ricxapp patch deploy kpm-basic-xapp --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/env","value":[{"name":"PYTHONPATH","value":"/app"}]}]'
kubectl -n ricxapp rollout restart deploy kpm-basic-xapp
kubectl -n ricxapp rollout restart deploy ricxapp-kpm-basic-xapp-597c5c7497-7ccm9
kubectl -n ricxapp rollout restart ricxapp-kpm-basic-xapp-597c5c7497-7ccm9
kubectl -n ricxapp patch ricxapp-kpm-basic-xapp-597c5c7497-7ccm9 --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/env","value":[{"name":"PYTHONPATH","value":"/app"}]}]'
kubectl get pods -n ricxapp
kubectl -n ricxapp get pods -w
kubectl -n ricxapp exec -it deploy/ricxapp-kpm-basic-xapp-597c5c7497-7
kubectl -n ricxapp exec -it deploy/ricxapp-kpm-basic-xapp-597c5c7497-7ccm9
kubectl -n ricxapp exec -it deploy/ricxapp-kpm-basic-xapp-597c5c7497-7ccm9 -- bash -lc   'pwd; ls -al /app; python -c "import sys,os;print(sys.path); import xDevSM; print(\"xDevSM OK\")"'
kubectl -n ricxapp exec -it ricxapp-kpm-basic-xapp-597c5c7497-7ccm9 -- bash -lc   'pwd; ls -al /app; python -c "import sys,os;print(sys.path); import xDevSM; print(\"xDevSM OK\")"'
kubectl get deploy -n ricxapp
kubectl -n ricxapp exec -it ricxapp-kpm-basic-xapp-597c5c7497-7ccm9 -- bash
kubectl -n ricxapp patch deploy ricxapp-kpm-basic-xapp --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/workingDir","value":"/app"}]'
kubectl -n ricxapp set env deploy/ricxapp-kpm-basic-xapp PYTHONPATH=/app
kubectl -n ricxapp patch deploy ricxapp-kpm-basic-xapp --type=json   -p='[{"op":"add","path":"/spec/template/spec/containers/0/command","value":["python","kpm_xapp.py"]}]'
kubectl -n ricxapp rollout restart deploy ricxapp-kpm-basic-xapp
kubectl -n ricxapp get pods -w
kubectl -n ricxapp get deploy ricxapp-kpm-basic-xapp -o yaml | sed -n '1,200p'
kubectl logs ricxapp-kpm-basic-xapp-6f9bbbb589-frc9z  -n ricxapp
# crea un pod di test con la stessa immagine
kubectl -n ricxapp run imgtest --rm -it   --image=192.168.17.70:5000/kpm_app:0.1.0 --restart=Never --   bash -lc 'pwd; ls -al /app; echo "---"; python - <<PY
import sys, os
print("sys.path:", sys.path)
print("exists /app/xDevSM:", os.path.exists("/app/xDevSM"))
try:
    import xDevSM
    print("import xDevSM: OK")
except Exception as e:
    print("import xDevSM: FAIL ->", e)
PY'
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.1
docker build -f docker/Dockerfile.kpm_basic_xapp -t 192.168.17.70:5000/kpm_app:0.1.1 .
docker push 192.168.17.70:5000/kpm_app:0.1.1
docker push localhost:5000/kpm_app:0.1.1
docker build -f docker/Dockerfile.kpm_basic_xapp -t localhost:5000/kpm_app:0.1.1 .
docker push localhost:5000/kpm_app:0.1.1
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.1
kubectl -n ricxapp get pods -w
kubectl logs ricxapp-kpm-basic-xapp-7d8d67d67d-7nsn8 -n ricxapp
logout
ls
history
pwd
ls
cd xDevSM-xapps-examples/
ls
helm install kpm-basic-xapp kpm-basic-xapp-0.2.0-dev.tgz -n ricxapp
helm uninstall kpm-basic-xapp -n ricxapp
helm install kpm-basic-xapp kpm-basic-xapp-0.2.0-dev.tgz -n ricxapp
ls
cd kpm
ls
cd kpm_basic_xapp/
ls
cd config/
ls
helm install kpm-basic-xapp kpm-basic-xapp-1.0.0.tgz -n ricxapp
cd ../..
ls
cd ..
ls
./runMinikube.sh 
kubectl get pods -n ricxapp
kubectl get pods -n ricxapp -w
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-tf5x4 -n ricxapp
helm uninstall kpm-basic-xapp -n ricxapp
ls
cd xDevSM-xapps-examples/
helm install kpm-basic-xapp kpm-basic-xapp-1.0.0.tgz -n ricxapp
helm install kpm-basic-xapp kpm-basic-xapp-0.2.0-dev.tgz -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-7547cdc77-jcbnc -n ricxapp -w
kubectl logs ricxapp-kpm-basic-xapp-7547cdc77-jcbnc -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-7547cdc77-jcbnc -n ricxapp
kubectl get pods -n ricxapp
ls
cd kpm_basic_xapp/
ls
cd config/
ls
helm uninstall kpm-basic-xapp
helm uninstall kpm-basic-xapp -n ricxapp
helm install kpm-basic-xapp kpm-basic-xapp-1.0.0.tgz -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-klrp9 -n ricxapp
helm uninstall kpm-basic-xapp -n ricxapp
ls
docker build -f docker/Dockerfile.kpm_basic_xapp -t 192.168.17.70:5000/kpm_app:0.1.1 .
docker build -f docker/Dockerfile.kpm_basic_xapp -t localhost:5000/kpm_app:0.1.2 .
docker push localhost:5000/kpm_app 0.1.2
history | grep push
docker build -f docker/Dockerfile.kpm_basic_xapp -t localhost:5000/kpm_app:0.1.2 .
docker push localhost:5000/kpm_app 0.1.2
docker images
docker build -f docker/Dockerfile.kpm_basic_xapp -t localhost:5000/kpm_app:0.1.2 .
docker push localhost:5000/kpm_app:0.1.2
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.2
docker build -f docker/Dockerfile.kpm_basic_xapp -t localhost:5000/kpm_app:0.1.2 .
docker images prune 
docker image prune 
docker build -f docker/Dockerfile.kpm_basic_xapp -t localhost:5000/kpm_app:0.1.2 .
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.2
git submodule init
git submodule update
ls
cd xDevSM/
ls
docker push localhost:5000/kpm_app:0.1.2
docker images
docker image prune eae04dbfb83a
docker image 
docker image rm eae04dbfb83a
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.2
docker image prune 
ls
docker image prune 
docker images
docker image rm 56a6d777d8f9 f78cd051737d bd717bee7357 eae04dbfb83a eae04dbfb83a a898840cce4b
docker images
docker image rm eae04dbfb83a eae04dbfb83a -f
docker images
ls
docker build -f docker/Dockerfile.kpm_basic_xapp -t localhost:5000/kpm_app:0.1.3 .
cd ..
docker build -f docker/Dockerfile.kpm_basic_xapp -t localhost:5000/kpm_app:0.1.3 .
docker images
docker push localhost:5000/kpm_app:0.1.3
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.3
helm uninstall kpm-basic-xapp -n ricxapp
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.3
dms_cli onboard ./kpm_basic_xapp/config/config-file.json ./kpm_basic_xapp/config/schema.json 
cd ..
ls
source ./bin/activate
nano attivaEnv.sh 
source ~/.venvs/dms/bin/activate
cd xDevSM-xapps-examples/
dms_cli onboard ./kpm_basic_xapp/config/config-file.json ./kpm_basic_xapp/config/schema.json 
history | grep export
export CHART_REPO_URL=http://0.0.0.0:8090
dms_cli onboard ./kpm_basic_xapp/config/config-file.json ./kpm_basic_xapp/config/schema.json 
dms_cli install kpm-basic-xapp 0.1.3 -n ricxapp
dms_cli install kpm-basic-xapp 0.1.3
dms_cli install kpm-basic-xapp:0.1.3
history | grep install
ls
dms_cli
dms_cli download_helm_chart kpm-basic-xapp 1.0.0
ls
helm install kpm-basic-xapp-1.0.0.tgz -n ricxapp
helm install kpm-basic-xapp kpm-basic-xapp-1.0.0.tgz -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-lrsxn -n  ricxapp
dms_cli download_helm_chart kpm-basic-xapp 1.0.1
dms_cli install kpm-basic-xapp:0.1.3
dms_cli install kpm-basic-xapp:0.1.3 -n ricxapp
dms_cli install kpm-basic-xapp 0.1.3 -n ricxapp
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.3
docker build -f docker/Dockerfile.kpm_basic_xapp 192.168.17.70:5000/kpm_app 0.1.2 .
docker build -f docker/Dockerfile.kpm_basic_xapp 192.168.17.70:5000/kpm_app:0.1.2 .
docker build -f docker/Dockerfile.kpm_basic_xapp -t 192.168.17.70:5000/kpm_app:0.1.2 .
docker push 192.168.17.70:5000/kpm_app:0.1.2
docker run --rm -it --entrypoint bash 192.168.17.70:5000/kpm_app:0.1.2 -lc  'ls -al /app/xDevSM; python -c "import sys;print(\"/app\" in sys.path); import xDevSM; print(\"OK\")"'
minikube image load 192.168.17.70:5000/kpm_app:0.1.2
cd kpm-basic-xapp/config/
ls
dms_cli onboard config-file.json schema.json
ls
cd ..
ls
cd ..
cd kpm_basic_xapp/
cd config/
dms_cli onboard config-file.json schema.json
kubectl get svc -n ricplt | egrep 'onboarder|helmrepo|appmgr|kong'
docker run --rm -u 0 -it -d -p 8090:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
export CHART_REPO_URL=http://0.0.0.0:8090
dms_cli onboard config-file.json schema.json
dms_cli install kpm-basic-xapp 1.0.0 -n ricxapp
history | grep "docker run"
docker run --rm -it -p 8080:8080 192.168.17.70:5000/kpm_app:0.12
docker run --rm -it -p 8080:8080 192.168.17.70:5000/kpm_app:0.1.2
cd ../..
docker images
docker image rm 7ea9ac9212a8 5091ee9ab71d -f
docker build -f docker/Dockerfile.kpm_basic_xapp -t 192.168.17.70:5000/kpm_app:0.1.0 .
docker run --rm -it -p 8080:8080 192.168.17.70:5000/kpm_app:0.1.0
cd kpm_basic_xapp/config/
dms_cli onboard config-file.json schema.json 
sudo rm -r /tmp/helm_template/kpm-basic-xapp
dms_cli install kpm-basic-xapp 1.0.0 -n ricxapp
docker run --rm -it -p 8080:8080 192.168.17.70:5000/kpm_app:0.1.0
sudo docker ps
sudo docker exec -it 8b069131bb4b bash
ls
helm uninstall kpm-basic-xapp 1.0.0 -n ricxapp
cd kpm_basic_xapp/config/
ls
cd ..
ls
cd ..
ls
sudo rm -r kpm-basic-xapp
rm kpm-basic-xapp-1.0.0.tgz 
cd kpm_basic_xapp/config/charts/
ls -l
unzip kpm-basic-xapp-1.0.0.tgz 
sudo apt install unzip
unzip kpm-basic-xapp-1.0.0.tgz 
ls
history | grep "docker push
history | grep "docker push"
docker push 192.168.17.70:5000/kpm_app:0.1.0
kubectl -n ricxapp get deploy ricxapp-kpm-basic-xapp -o=jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
kubectl -n ricxapp describe pods -l app=ricxapp-kpm-basic-xapp
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp ricxapp-kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.0
kubectl -n ricxapp rollout restart deploy ricxapp-kpm-basic-xapp
kubectl -n ricxapp set image ricxapp-kpm-basic-xapp ricxapp-kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.0
kubectl -n ricxapp set image deploy/deployment-ricxapp-kpm-basic-xapp ricxapp-kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.0
history | grep "set image"
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.0
cd ..
c d..
cd ..
docker build -f docker/Dockerfile.kpm_basic_xapp 192.168.17.70:5000/kpm_app:0.1.4
docker build -f docker/Dockerfile.kpm_basic_xapp 192.168.17.70:5000/kpm_app:0.1.4 .
docker build -f docker/Dockerfile.kpm_basic_xapp -t 192.168.17.70:5000/kpm_app:0.1.4 .
docker push 192.168.17.70:5000/kpm_app:0.1.4
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.4
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-7d8d67d67d-7nsn8 -n ricxapp
kubectl rollout restart ricxapp-kpm-basic-xapp-7d8d67d67d-7nsn8 -n ricxapp
kubectl rollout restart ricxapp-kpm-basic-xapp-7d8d67d67d-7nsn8
kubectl get service -n ricxapp
kubectl -n ricxapp rollout restart deploy ricxapp-kpm-basic-xapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-677fc8b8f6-bf96l -n ricxapp
kubectl -n ricxapp set env deploy/ricxapp-kpm-basic-xapp CONFIG_FILE=/opt/ric/config/config-file.json
kubectl -n ricxapp rollout restart deploy/ricxapp-kpm-basic-xapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-968c78699-h6wwh -n ricxapp
kubectl get pods -n ricxapp
ps aux --sort=-pcpu
ps aux --sort=-pcpu | head -n 5
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-968c78699-h6wwh -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-968c78699-h6wwh -n ricxapp
kubectl -n ricxapp rollout restart deploy ricxapp-kpm-basic-xapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-79479bbc84-m7f4t -n ricxapp
kubectl -n ricxapp rollout status deploy/ricxapp-kpm-basic-xapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-78677985f7-grhqp  -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-78677985f7-grhqp  -n ricxapp -w
kubectl logs ricxapp-kpm-basic-xapp-78677985f7-grhqp  -n ricxapp f
kubectl logs ricxapp-kpm-basic-xapp-78677985f7-grhqp  -n ricxap -f
kubectl logs ricxapp-kpm-basic-xapp-78677985f7-grhqp  -n ricxapp
kubectl -n ricxapp rollout status deploy/ricxapp-kpm-basic-xapp
kubeclt get pods -n ricxapp
kubectl get pods -n ricxapp
kubectl -n ricxapp rollout status deploy/ricxapp-kpm-basic-xapp
kubectl -n ricxapp rollout restart deploy/ricxapp-kpm-basic-xapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-76df7c8556-hwdxr -n ricxapp
kubectl -n ricxapp rollout restart deploy/ricxapp-kpm-basic-xapp
kubectl get pods -n ricxapp
docker run --rm -it --entrypoint bash localhost:5000/kpm_app:0.1.3 -lc  'ls -al /app/xDevSM; python -c "import sys;print(\"/app\" in sys.path); import xDevSM; print(\"OK\")"'
minikube ssh -- curl -s http://192.168.17.70:5000/v2/_catalog
minikube image load 192.168.17.70:5000/kpm_app:0.1.3
kubectl -n ricxapp get deploy ricxapp-kpm-basic-xapp -o=jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
minikube image load 192.168.17.70:5000/kpm_app:0.1.3
kubectl -n ricxapp rollout restart deploy ricxapp-kpm-basic-xapp
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json >/dev/null <<'EOF'
{
  "insecure-registries": ["192.168.17.70:5000"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
docker info | sed -n '/Insecure Registries/,$p'
docker tag kpm_app:0.1.3 192.168.17.70:5000/kpm_app:0.1.3
docker push 192.168.17.70:5000/kpm_app:0.1.3
ls
./runMinikube.sh 
nano runMinikube.sh 
./runMinikube.sh 
kubectl get pods -n ricxapp
docker images
minikube image load 192.168.17.70:5000/kpm_app:0.1.2
kubectl get pods -n ricxapp
kubectl -n ricxapp run imgtest --rm -it   --image=192.168.17.70:5000/kpm_app:0.1.2 --restart=Never --   bash -lc 'ls -al /app; ls -al /app/xDevSM; python -c "import sys;print(sys.path); import xDevSM; print(\"OK\")"'
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.2
minikube image load 192.168.17.70:5000/kpm_app:0.1.2
# usa il nuovo tag
kubectl -n ricxapp set image deploy/ricxapp-kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.2
# assicurati workingDir/command/env coerenti:
kubectl -n ricxapp patch deploy ricxapp-kpm-basic-xapp --type=json   -p='[
    {"op":"add","path":"/spec/template/spec/containers/0/workingDir","value":"/app"},
    {"op":"add","path":"/spec/template/spec/containers/0/command","value":["python","kpm_xapp.py"]}
  ]' 2>/dev/null || true
kubectl -n ricxapp set env deploy/ricxapp-kpm-basic-xapp PYTHONPATH=/app
minikube ssh -- curl -s http://192.168.17.70:5000/v2/_catalog
kubectl -n ricxapp set image deploy/kpm-basic-xapp   kpm-basic-xapp=192.168.17.70:5000/kpm_app:0.1.2
kubectl -n ricxapp patch deploy ricxapp-kpm-basic-xapp --type=json   -p='[
    {"op":"add","path":"/spec/template/spec/containers/0/workingDir","value":"/app"},
    {"op":"add","path":"/spec/template/spec/containers/0/command","value":["python","kpm_xapp.py"]}
  ]' 2>/dev/null || true
minikube image load 192.168.17.70:5000/kpm_app:0.1.2
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-597c5c7497-hbhtv -n ricxapp
kubectl -n ricxapp rollout restart deploy kpm-basic-xapp
kubectl -n ricxapp rollout restart deploy ricxapp-kpm-basic-xapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-7f4bcb4c76-9kbdt -n ricxapp
kubectl -n ricxapp rollout restart deploy ricxapp-kpm-basic-xapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-75cf95d6c6-9xhvl -n ricxapp
kubectl exec -it ricxapp-kpm-basic-xapp-75cf95d6c6-9xhvl
kubectl exec -it ricxapp-kpm-basic-xapp-75cf95d6c6-9xhvl -- /bin/bash
kubectl exec -it ricxapp-kpm-basic-xapp-75cf95d6c6-9xhvl -n ricxapp -- /bin/bash
kubectl get pods -n ricxapp
kubectl exec -it ricxapp-kpm-basic-xapp-597c5c7497-vxpxg -n ricxapp -- /bin/bash
kubectl get pods -n ricxapp
kubectl exec -it ricxapp-kpm-basic-xapp-67dddfdf49-gcskz -n ricxapp -- /bin/bash
kubectl get pods -n ricxapp
kubectl exec -it ricxapp-kpm-basic-xapp-5c8fc85fd5-8pktz -n ricxapp -- /bin/bash
ls
kubectl get pods -n ricxapp
kubectl exec -it ricxapp-kpm-basic-xapp-5c8fc85fd5-8pktz -n ricxapp -- /bin/bash
kubectl logs ricxapp-kpm-basic-xapp-5c8fc85fd5-8pktz -n ricxapp
kubectl -n ricxapp run imgtest --rm -it   --image=192.168.17.70:5000/kpm_app:0.1.2 --restart=Never --   bash -lc 'ls -al /app; ls -al /app/xDevSM; python -c "import sys;print(sys.path); import xDevSM; print(\"OK\")"'
sudo tcpdump -i any sctp 
sudo iptables -t nat -S PREROUTING | grep 32222
sudo iptables -S FORWARD | egrep 'sctp|32222'
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
# MASQ
sudo iptables -t nat -I POSTROUTING 1 -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
# FORWARD
sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
nano runMinikube.sh 
sudo iptables -t nat -C PREROUTING -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222   || sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -C POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE   || sudo iptables -t nat -A POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -C FORWARD -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -C FORWARD -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT   || sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m state --state ESTABLISHED,RELATED -j ACCEPT
nano script.sh 
./script.sh 
sudo iptables -t nat -S PREROUTING | grep 32222
sudo iptables -t nat -S POSTROUTING | grep 32222
sudo iptables -S FORWARD | egrep 'sctp|32222'
sudo iptables -S DOCKER-USER | egrep 'sctp|32222'
sudo tcpdump -i any sctp -vvD
sudo iptables -n nat
sudo iptables -t nat -L
sudo iptables -L
sudo iptables -t nat -D PREROUTING -p sctp -d 172.17.0.1 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -I PREROUTING 1 -i ens18 -p sctp -d 192.168.17.70 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -I PREROUTING 2 -i ens18 -p sctp -d 172.17.0.1 --dport 32222 -j DNAT --to-destination 192.168.49.2:32222
sudo iptables -t nat -D POSTROUTING -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -t nat -I POSTROUTING 1 -p sctp -d 192.168.49.2 --dport 32222 -j MASQUERADE
sudo iptables -I FORWARD 1 -p sctp -d 192.168.49.2 --dport 32222 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD 1 -p sctp -s 192.168.49.2 --sport 32222 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I DOCKER-USER 1 -p sctp -d 192.168.49.2 --dport 32222 -j ACCEPT
sudo iptables -I DOCKER-USER 1 -p sctp -s 192.168.49.2 --sport 32222 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo modprobe sctp
sudo modprobe nf_conntrack_sctp
sudo modprobe nf_nat_sctp 2>/dev/null || true
sudo modprobe br_netfilter
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=2
sudo sysctl -w net.ipv4.conf.default.rp_filter=2
sudo sysctl -w net.ipv4.conf.ens18.rp_filter=2
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
sudo netfilter-persistent save
cat /etc/iptables/rules.v4
sudo cat /etc/iptables/rules.v4
sudo cat /etc/iptables/rules.v4 | grep "-A PREROUTING -i ens18 -p sctp -d 192.168.17.70"
sudo cat /etc/iptables/rules.v4 | grep "-A PREROUTING"
sudo tee /etc/systemd/system/ric-iptables.service >/dev/null <<'EOF'
[Unit]
Description=RIC iptables rules (post-Docker)
After=network-online.target docker.service
Wants=docker.service

[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore /etc/iptables/rules.v4
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now netfilter-persistent ric-iptables.service
nano runMinikube.sh 
history | grep "rollout"
pwd
ls
kubectl get pods -n ricxapp
kubectl rollout restart deploy kpm-basic-xapp -n ricxapp
kubectl rollout restart deploy ricxapp-kpm-basic-xapp -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-775f557cf9-ltmqd -n ricxapp
kubectl rollout restart deploy ricxapp-kpm-basic-xapp -n ricxapp
kubectl get pods -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-5db9c4c79d-ggc5s -n ricxapp
kubectl logs ricxapp-kpm-basic-xapp-5db9c4c79d-ggc5s -n ricxappù
kubectl logs ricxapp-kpm-basic-xapp-5db9c4c79d-ggc5s -n ricxapp
