

## 1. Adressage
🌞 **Vous me rendrez un 🗃️ tableau des réseaux 🗃️ qui rend compte des adresses choisies, sous la forme** :


| Nom du réseau | Adresse du réseau | Masque        | Nombre de clients possibles | Adresse passerelle | [Adresse broadcast](../../cours/lexique/README.md#adresse-de-diffusion-ou-broadcast-address) |
|---------------|-------------------|---------------|-----------------------------|--------------------|----------------------------------------------------------------------------------------------|
| `server1`     | `10.3.0.0`        | `255.255.255.128` | 126                          | `10.3.0.126`         | `10.3.0.127`                                                                                   |
| `client1`     | `10.3.0.128`        | `255.255.255.192` | 62                         | `10.3.0.190`         | `10.3.0.191`                                                                                   |
| `server2`     | `10.3.0.192`        | `255.255.255.240` | 14                           | `10.3.0.207`         | `10.3.0.208`                                                                                   |

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
