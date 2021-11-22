# TP_3 Make your own shiet

Pour ce dernier TP,  je vais utiliser une application deja crée. Cette dernière est constitue d'un serveur web nginx qui sert un front-web en VueJs avec un back-end en ExpressJS, le tout sera déployé a l'aide d'un cluster rassemblant des conteneurs réalisé a l'aide de la technologie Kubernetes.

Le cluster sera creer sur trois machines virtuelles CentOS8 installes avec VirtualBox. 

## Installation

### 1. Configuration des VM

Les deux VM possèdent deux CPUm 2Go de RAM, et de 12Go d'espace disque. Une deuxième interface en plus de la NAT est crée avec comme Mode d'acces réseau Host-only ayant pour IP 192.168.0.1/24. Une fois la distribution installée je commence par désactivé SElinux en rajoutant au fichier de conf.
Le cluster sera compose de deux workers  nodes et de seulement un noeud master. Les Machines pourront communiquer a l'aide des IP's suivantes:

 - Master-node: 192.168.0.47/24
 - Worker-node: 192.168.0.48/24
 - Worker-node: 192.168.0.49/24
```
[yloisel@master-node ~]$ cat /etc/sysconfig/selinux

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

Puis ensuite je modifie mon hostname a la fois pour le noeud master (master-node)et deux noeuds workers (node-1 et node-2).
```
[yloisel@master-node ~]$ hostname
master-node
```

Je modifie le fichier etc/hosts utiles cour la manipulation du cluster avec kubernetes.
master-node
```
[yloisel@master-node ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.0.47 master-node
192.168.0.48 node-1 worker-node-1
192.168.0.49 node-2 worker-node-2
master-node
```
Je verifie que la resolution de noms a bien ete changee et que toutes machines peuvent se ping.
```
[yloisel@master-node ~]$ ping node-2
PING node-2 (192.168.0.49) 56(84) bytes of data.
64 bytes from node-2 (192.168.0.49): icmp_seq=1 ttl=64 time=0.891 ms
```
Je modfifie par la suite les regles du firewall en autorisant les ports suivants necessaires pour la communication des machines dans le cluster.
```
[yloisel@master-node ~]$ firewall-cmd --permanent --add-port=6443/tcp

[yloisel@master-node ~]$ firewall-cmd --permanent --add-port=2379-2380/tcp

[yloisel@master-node ~]$ firewall-cmd --permanent --add-port=10250/tcp

[yloisel@master-node ~]$ firewall-cmd --permanent --add-port=10251/tcp

[yloisel@master-node ~]$ firewall-cmd --permanent --add-port=10252/tcp

[yloisel@master-node ~]$ firewall-cmd --permanent --add-port=10255/tcp

[yloisel@master-node ~]$ firewall-cmd –reload
```



Selon la doc de kubernetes on s'assure que le module br_netfilter soit chargé et que la swap soit désactivé.
```
[yloisel@master-node ~]$ sudo modprobe br_netfilter && swapoff -a
```
Et on s'assure que le fichier /proc/sys/net/bridge/bridge-nf-call-iptables soit set sur 1, afin que les iptables de nos nœud Linux voient correctement le trafic ponté
```
[yloisel@master-node ~]$ sudo cat /proc/sys/net/bridge/bridge-nf-call-iptables
1
```

On installe ensuite Docker sur nos machines en ajoutant le repo de docker non par fourni par defaut par dnf.
```
[yloisel@master-node ~]$dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
[yloisel@master-node ~]$dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
```

On démarre le service en on le lance au boot de la machine.
```
[yloisel@master-node ~]$ # systemctl start docker && systemctl enable docker
```
 On installe ensuite K8s en rajoutant la reference au repo dans le dossier /etc/yum.repos.d
 ```
 [yloisel@master-node ~]$ cat /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
```

On installe kubeadm qui nous permettra plus tard pour demarrer notre cluster.
```
 [yloisel@master-node ~]$dnf install kubeadm -y
 ```
On demarre le process kubelet en s'assurant qu'ils soient actifs sur toutes les machines.
```
[yloisel@master-node ~]$ systemctl start kubelet && systemctl enable kubelet
```


## Initialisation du cluster

On va maintenant initialiser le noeud master et créer le cluster.
```
 [yloisel@master-node ~]$ sudo kubeadm init --apiserver-advertise-address 192.168.0.47 --pod-network-cidr=192.168.0.0/24
[init] Using Kubernetes version: v1.22.4
[preflight] Running pre-flight checks
 ```
Le process d'initialisation va executer des tests pour s'assurer que la kubernetes se lance correctement.

Le resultat de cette commande nous retournera une commande de la forme suivante qu'il faudra executer sur les workers. 
 ```
kubeadm join 192.168.0.47:6443 --token nu06lu.xrsux0ss0ixtnms5  \ --discovery-token-ca-cert-hash ha256:f996ea35r4353d342fdea2997a1cf8caeddafd6d4360d606dbc82314683478hjmf7
 ```

Ensuite on on accorde les droits a notre user  d'utiliser notre cluster.
```
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
 ```

On teste avec:
 ```
[yloisel@master-node .kube]$ kubectl get nodes
NAME          STATUS     ROLES                  AGE     VERSION
master-node   Ready      control-plane,master   2d21h   v1.22.3
node-1        NotReady   <none>                 2d21h   v1.22.3
node-2        NotReady   <none>                 2d21h   v1.22.3
 ```


Pour assurer la connexion entre nos pods on utilise le plugin Weavenet et on l'applique a notre cluster.
 ```
 [yloisel@master-node .kube]$export kubever=$(kubectl version | base64 | tr -d '\n')
[yloisel@master-node .kube]$kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
 ```


On initialise nos noeuds workers avec la commande précédente.
 ```
 [yloisel@master-node .kube]$kubeadm join 192.168.0.47:6443 --token nu06lu.xrsux0ss0ixtnms5  \ --discovery-token-ca-cert-hash ha256:f996ea35r4353d342fdea2997a1cf8caeddafd6d4360d606dbc82314683478hjmf7
  ```
Depuis le master on peut tester que tous nos noeuds possèdent le status ready.
  ```
[yloisel@master-node .kube]$ kubectl get nodes
NAME          STATUS     ROLES                  AGE     VERSION
master-node   Ready      control-plane,master   2d21h   v1.22.3
node-1        Ready   <none>                 2d21h   v1.22.3
node-2        Ready      <none>                 2d21h   v1.22.3
  ```

Pour simplifier l'installation il serait utile de faire un script s'assurant que la machine soit opérationnelle pour installer un cluster kubernetes. Ceci est sans doute une piste d'amelioration pour cette doc.

Pour simplifier l'utilisation et la gestion de notre cluster je prefere gerer mon cluster depuis ma machine hote. Pour cela j'installe kubectl sur ma machine, dans le dossier suivant je creer un fichier config-mycluster et je copie le fichier de notre master ~/.kube./config dans le fichier suivant dans ma machine hote:  ~/.kube/config-mycluster.

On change ensuite notre current-context avec la commande suivante.
  ```
[yloisel@master-node .kube yanissloisel@mbp-de-yaniss  ~/.kube  kubectl config --kubeconfig=config-1 use-context kubernetes-admin@kubernetes
  ```

On rajoute ensuite le chemin de ce fichier de configuration dans la variable d'environnement `KUBECONFIG`.

```
export KUBECONFIG=~/.kube/config-1
```


Deploiment de la solution 