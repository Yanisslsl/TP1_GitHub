

## 1. Adressage
🌞 **Vous me rendrez un 🗃️ tableau des réseaux 🗃️ qui rend compte des adresses choisies, sous la forme** :


| Nom du réseau | Adresse du réseau | Masque        | Nombre de clients possibles | Adresse passerelle | [Adresse broadcast](../../cours/lexique/README.md#adresse-de-diffusion-ou-broadcast-address) |
|---------------|-------------------|---------------|-----------------------------|--------------------|----------------------------------------------------------------------------------------------|
| `server1`     | `10.3.0.0`        | `255.255.255.128` | 126                          | `10.3.0.126`         | `10.3.0.127`                                                                                   |
| `client1`     | `10.3.0.128`        | `255.255.255.192` | 62                         | `10.3.0.190`         | `10.3.0.191`                                                                                   |
| `server2`     | `10.3.0.192`        | `255.255.255.240` | 14                           | `10.3.0.206`         | `10.3.0.207`                                                                                   |

🌞 **Vous remplirez aussi** au fur et à mesure que vous avancez dans le TP, au fur et à mesure que vous créez des machines, **le 🗃️ tableau d'adressage 🗃️ suivant :**

| Nom machine  | Adresse IP `client1` | Adresse IP `server1` | Adresse IP `server2` | Adresse de passerelle |
|--------------|----------------------|----------------------|----------------------|-----------------------|
| `router.tp3` | `10.3.0.126/25`         | `10.3.0.190/26`         | `10.3.0.207/28`         | Carte NAT             |
| ...          | ...                  | ...                  | ...                  | `10.0.2.15/24`          |

## 2.routage 

J'active le routage sur la machine.
```
[yaniss@router ~]$ sudo firewall-cmd --add-masquerade --zone=public --permanent
[sudo] Mot de passe de yaniss :
Warning: ALREADY_ENABLED: masquerade
success
```

Je verifie mon acces a internet et ma résolution de noms.
```

[yaniss@router ~]$ ping google.com
PING google.com (142.250.179.110) 56(84) bytes of data.
64 bytes from par21s20-in-f14.1e100.net (142.250.179.110): icmp_seq=1 ttl=63 time=18.3 ms
64 bytes from par21s20-in-f14.1e100.net (142.250.179.110): icmp_seq=2 ttl=63 time=22.0 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 18.336/20.177/22.018/1.841 ms
```

J'affiche mes interfaces possedant chacune une ip dans les 3 réseaux.
```

[yaniss@router ~]$ ip a

3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:3e:16:27 brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.126/25 brd 10.3.0.127 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::4396:cef4:18af:8cbb/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:c1:ee:c4 brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.190/26 brd 10.3.0.191 scope global noprefixroute enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::bb34:9702:7096:f3ff/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: enp0s10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:2e:6a:8e brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.207/28 brd 10.3.0.207 scope global noprefixroute enp0s10
       valid_lft forever preferred_lft forever
    inet6 fe80::4bf0:3d8a:c541:4c94/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

Je verfie mon hostname.
```

[yaniss@router ~]$ hostname
router.tp3
```


## II.Services d'infra

### 1.Serveur DHCP

#### 🌞 Mettre en place une machine qui fera office de serveur DHCP dans le réseau client1. Elle devra :

Je vérifie le nom de la VM
```

[yaniss@dhcp ~]$ hostname
dhcp.client1.tp3
```
Je modifie le fichier de conf du dhcp et modifiant les fiels nécessaires.
```

[yaniss@dhcp ~]$ sudo cat /etc/dhcp/dhcpd.conf
[sudo] Mot de passe de yaniss :
ddns-update-style none;
ignore client-updates;
authoritative;
subnet 10.3.0.128 netmask 255.255.255.192 {
	 option routers 10.3.0.190;		# passerelle par défaut
        option subnet-mask 255.255.255.192;	# masque de sous-réseau
        option domain-name "home.lan";		# nom de domaine
        option domain-name-servers 1.1.1.1;# serveurs DNS
        range 10.3.0.129 10.3.0.188;	# plage d’adresse
        default-lease-time 21600;		# durée du bail en secondes
        max-lease-time 43200 ;			# durée maxi du bail en sec.
#Si on veut faire des réservations (attribuer tout le temps la même IP
# a un certain  équipement) on les insérera ici.
}
```
#### 🌞 Mettre en place un client dans le réseau client1

Je modifie le nom de la VM 
```

[yaniss@marcel ~]$ hostname
marcel.client.tp3
```

L'IP de la VM est bien donnée dynamiquement par le serveur DHCP
```

[yaniss@marcel ~]$ ip a
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:65:dc:a2 brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.130/26 brd 10.3.0.191 scope global dynamic noprefixroute enp0s8
       valid_lft 21261sec preferred_lft 21261sec
    inet6 fe80::4396:cef4:18af:8cbb/64 scope link dadfailed tentative noprefixroute
       valid_lft forever preferred_lft forever
    inet6 fe80::25ee:59cf:8284:5f66/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```
 Le seveur DNS est bien celui spécifié par le serveur DHCP.
```
 
 [yaniss@marcel ~]$ dig
[...]

;; Query time: 40 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
```
#### 🌞 Depuis marcel.client1.tp3
Et finalement je peux vérifier si je possede bien une résolution de noms et un acces a internet.

```
[yaniss@marcel ~]$ ping google.com
PING google.com (142.250.178.142) 56(84) bytes of data.
64 bytes from par21s22-in-f14.1e100.net (142.250.178.142): icmp_seq=1 ttl=61 time=27.4 ms
64 bytes from par21s22-in-f14.1e100.net (142.250.178.142): icmp_seq=2 ttl=61 time=18.7 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 18.723/23.078/27.433/4.355 ms
```

Avec la commande traceroute je peux verifier le chemin emprunté pour sortir du reseau,
qui comme écris ci dessous est la gateway 10.3.0.190 correspondant a l'une des ip de router.tp3
```

[yaniss@marcel ~]$ traceroute ynov.com
traceroute to ynov.com (92.243.16.143), 30 hops max, 60 byte packets
 1  _gateway (10.3.0.190)  1.152 ms  1.148 ms  1.028 ms
 2  10.0.2.2 (10.0.2.2)  1.001 ms  0.974 ms  0.854 ms
```

## 2.Serveur

### B.Setup Copain

#### 🌞 Mettre en place une machine qui fera office de serveur DNS

sudo cat /etc/named.conf

options {
        listen-on port 53 { 127.0.0.1;any; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { localhost;any; };
	[..]
	
	zone "server1.tp3" IN {
        type master;
        file "server1.tp3.forward";
        allow-update {10.3.0.130;};
};

sudo cat /var/etc/server1.tp3.forward
$TTL 86400
@   IN  SOA dns.server1.tp3. admin.server1.tp3. (
        2021062301   ; serial
        3600         ; refresh
        1800         ; retry
        604800       ; expire
        86400 )      ; minimum TTL
;
; define nameservers
    IN  NS  dns.server1.tp3.
;
; DNS Server IP addresses and hostnames
dns IN  A   10.3.0.100
;
;client records
router IN  A   10.3.0.190

### 🌞 Tester le DNS depuis marcel.client1.tp3
#### définissez manuellement l'utilisation de votre serveur DNS

cat /etc/resol.conf
nameserver 10.3.1.2


#### essayez une résolution de nom avec dig
[yaniss@marcel ~]$ dig ynov.com

;; Query time: 3 msec
;; SERVER: 10.3.0.100#53(10.3.0.100)


### 1. Serveur Web

[yaniss@web1 ~]$ sudo dnf install nginx

[yaniss@web1 ~]$ sudo systemctl enable nginx

[yaniss@web1 ~]$ sudo systemctl start nginx

[yaniss@web1 ~]$ sudo firewall-cmd --zone=public --add-service=http --permanent


Je teste depuis marcel.client

[yaniss@marcel ~]$ curl web1
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
	  
# 2. Partage de fichiers
	  
## B. Le setup wola
	  
### 🌞 Setup d'une nouvelle machine, qui sera un serveur NFS
	  
[yaniss@nfs1 nfs_share]$ sudo dnf install nfs-utils -y

[yaniss@nfs1 nfs_share]$ sudo cat  /etc/idmapd.conf
[General]
#Verbosity = 0
# The following should be set to the local NFSv4 domain name
# The default is the host's DNS domain name.
Domain = srv.world

	  
[yaniss@nfs1 nfs_share]$ sudo cat /etc/exports
/srv/nfs_share  10.3.0.199(rw,no_root_squash)

[yaniss@nfs1 nfs_share]$ sudo mkdir /srv/nfs_share
	  
[yaniss@nfs1 nfs_share]$ sudo exportfs -r

[yaniss@nfs1 nfs_share]$ sudo touch toto
	
	  
### 🌞 Configuration du client NFS
	  
	  
[yaniss@web1 ]$ sudo cat  /etc/idmapd.conf
[General]
#Verbosity = 0
# The following should be set to the local NFSv4 domain name
# The default is the host's DNS domain name.
Domain = srv.world

[yaniss@web1 nfs]$ sudo mkdir /srv/nfs
	  
[yaniss@web1 nfs]$ sudo  mount -t nfs -vvvv 10.3.0.200:/srv/nfs_share/ /srv/nfs/
	  
[yaniss@web1 nfs]$ pwd
/srv/nfs

[yaniss@web1 nfs]$ ls
toto
	  
	  
	  
	  rsync --remove-source files
	  

#### IV. Un peu de théorie : TCP et UDP
	  
### V. El final
	  
Les échanges NFS, SSH et et HTTP sont encapsulés dans des trames TCP tandis que les échanges DNS sont encapsulés dans des trames UDP.
	  
### V. El final
	  
| Nom machine  | Adresse IP `client1` | Adresse IP `server1` | Adresse IP `server2` | Adresse de passerelle |
|--------------|----------------------|----------------------|----------------------|-----------------------|
| `router.tp3` | `10.3.0.126/25`         | `10.3.0.190/26`         | `10.3.0.207/28`         | Carte NAT             |
|          | ...                  | ...                  | ...                  | `10.0.2.15/24`          |
	  
| Nom machine        | Adresse IP `client1` | Adresse IP `server1` | Adresse IP `server2` | Adresse de passerelle  |
|--------------------|----------------------|----------------------|----------------------|------------------------|
| `router.tp3`       | `10.3.0.190/26`      | `10.3.0.126/25`      | `10.3.0.206/28`      | Carte NAT              |
| `dhcp.client1.tp3` | `10.3.0.189/26`      |                      |                      |                        |
|`marcel.client.tp3`| `10.3.0.130/26`      |                      |                      | `router``10.3.0.190/26`|
|`dns1.server1.tp3`  |                      | `10.3.0.2/25`        |                      | `router``10.3.0.126/25`|
|`johnny.server1.tp3`| `10.3.0.133/25`      |                      |                      | `router``10.3.0.126/25`|
|`web1.server2.tp3`  |                      |                      | `10.3.0.194/28`      | `router``10.3.0.206/28`|
|`nfs1.server2.tp3`  |                      |                      | `10.3.0.195/28`      | `router``10.3.0.206/28`|


