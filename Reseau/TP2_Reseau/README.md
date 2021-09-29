
# TP2 : On va router des trucs
# I. ARP
## 1. Echange ARP
### 🌞 Générer des requêtes ARP
### effectuer un ping d'une machine à l'autre
```
$ ping 10.2.1.11
PING 10.2.1.11 (10.2.1.11) 56(84) bytes of data.
64 bytes from 10.2.1.11: icmp_seq=1 ttl=64 time=0.958 ms
64 bytes from 10.2.1.11: icmp_seq=2 ttl=64 time=0.902 ms
```
### observer les tables ARP des deux machines
node1.net1.tp2
```
$ arp -a
_gateway (10.0.2.2) at 52:54:00:12:35:02 [ether] on enp0s3
? (10.2.1.12) at 08:00:27:9e:dd:b5 [ether] on enp0s8
? (10.2.1.1) at 0a:00:27:00:00:01 [ether] on enp0s8
```
Adresse MAC de node1 = 08:00:27:9e:dd:b5
node2.net1.tp2
```
$ arp -a
_gateway (10.0.2.2) at 52:54:00:12:35:02 [ether] on enp0s3
? (10.2.1.11) at 08:00:27:7f:fb:cc [ether] on enp0s8
? (10.2.1.1) at 0a:00:27:00:00:01 [ether] on enp0s8
```
Adresse MAC de node1 = 08:00:27:7f:fb:cc
La commande `arp -a` nous montre la mac mais également l'interface, afin de vérifier si l'information est vrai -> ip a
On cherche l'interface correspondante (enp0s8).
node1.net1.tp2
```
$ ip a
...
link/ether 08:00:27:7f:fb:cc ...
...
```
node2.net1.tp2
```
$ ip a
...
link/ether 08:00:27:9e:dd:b5 ...
...
```
## 2. Analyse de trames
### 🌞 Analyse de trames
|ordre | type trame | source                  | destination              |
|------|------------|-------------------------|--------------------------|
|  1   | Requête ARP| node2 08:00:27:9e:dd:b5 | Broadcast FF:FF:FF:FF:FF |
|  2   | Réponse ARP| node1 08:00:27:7f:fb:cc | node2 08:00:27:9e:dd:b5  |
# II. Routage
## 1. Mise en place du routage
### 🌞 Activer le routage sur le noeud router.2.tp2
```
[arnaud@router ~]$ sudo firewall-cmd --add-masquerade --zone=public --permanent
success
```
### 🌞 Ajouter les routes statiques nécessaires pour que node1.net1.tp2 et marcel.net2.tp2 puissent se ping
```
[arnaud@node1 ~]$ ping 10.2.2.12                        | [arnaud@marcel ~]$ ping 10.2.1.11
PING 10.2.2.12 (10.2.2.12) 56(84) bytes of data.        | PING 10.2.1.11 (10.2.1.11) 56(84) bytes of data.
64 bytes from 10.2.2.12: icmp_seq=1 ttl=63 time=1.66 ms | 64 bytes from 10.2.1.11: icmp_seq=1 ttl=63 time=0.912 ms
64 bytes from 10.2.2.12: icmp_seq=2 ttl=63 time=1.40 ms | 64 bytes from 10.2.1.11: icmp_seq=2 ttl=63 time=1.43 ms
```
## 2. Analyse de trames
### 🌞 Analyse des échanges ARP
| ordre | type trame  | IP source | MAC source                 | IP destination | MAC destination            |
|-------|-------------|-----------|----------------------------|----------------|----------------------------|
| 1     | Requête ARP | 10.2.1.11 | `node1` `08:00:27:20:59:0f`| 10.2.1.255     |Broadcast`ff:ff:ff:ff:ff:ff`|
| 2     | Réponse ARP | 10.2.1.254| `router``08:00:27:3e:16:27`| 10.2.1.11      | `node1``08:00:27:20:59:0f` |
| 3     | Ping        | 10.2.1.11 | `node1``08:00:27:20:59:0f` | 10.2.1.12      |`router``08:00:27:3e:16:27` |
| 4     | Requête ARP | 10.2.2.254| `router``08:00:27:3e:16:27`| 10.2.2.255     |Broadcast`ff:ff:ff:ff:ff:ff`|
| 5     | Réponse ARP | 10.2.2.12 | `marcel``08:00:27:65:dc:a2`| 10.2.2.254     |`router``08:00:27:e8:d7:73` |
| 6     | Ping        | 10.2.2.254| `router``08:00:27:e8:d7:73`| 10.2.1.12      | `marcel``08:00:27:df:dd:b3`|
| 7     | Pong        | 10.2.1.12 | `marcel``08:00:27:65:dc:a2`| 10.2.2.254     | `router``08:00:27:e8:d7:73`|
| 8     | Pong        | 10.2.1.254| `router``08:00:27:3e:16:27`| 10.2.1.11      | `node1` `08:00:27:20:59:0f`|







3. Accès internet
```

[yaniss@node1 ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=63 time=18.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=63 time=18.8 ms
^X64 bytes from 8.8.8.8: icmp_seq=3 ttl=63 time=18.2 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 18.165/18.382/18.770/0.296 ms
```
```

[yaniss@marcel ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=63 time=18.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=63 time=18.8 ms
^X64 bytes from 8.8.8.8: icmp_seq=3 ttl=63 time=18.2 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 18.165/18.382/18.770/0.296 ms
```
```

[yaniss@marcel ~]$ dig 
;; SERVER: 1.1.1.1#53(1.1.1.1)

[yaniss@node1 ~]$ dig 
;; SERVER: 1.1.1.1#53(1.1.1.1)
```

| ordre | type trame | IP source           | MAC source               | IP destination | MAC destination |     |
|-------|------------|---------------------|--------------------------|----------------|-----------------|-----|
| 1     | ping       | `node1` `10.2.1.12` | `node1` `08:00:27:20:59:0f` | `8.8.8.8`      | `router``08:00:27:3e:16:27`             |     |
| 2     | pong       |      `router``10.2.2.254        `| `router``08:00:27:3e:16:27`                    | `node1` `10.2.1.12`           |  `node1` `08:00:27:20:59:0f`        



### III.DHCP

#### 🌞 Sur la machine node1.net1.tp2, vous installerez et configurerez un serveur DHCP (go Google "rocky linux dhcp server").
```

[yaniss@node1 ~]$ ip a
[...]
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:20:59:0f brd ff:ff:ff:ff:ff:ff
    inet 10.2.1.2/24 brd 10.2.1.255 scope global dynamic noprefixroute enp0s8
[...]
```
#### 🌞 Améliorer la configuration du DHCP

Je rajoute ces lignes au fichier de configuration de mon serveur DHCP.
```

max-lease-time 7200;
# this DHCP server to be declared valid
authoritative;
# specify network address and subnetmask
subnet 10.2.1.0 netmask 255.255.255.0 {
    # specify the range of lease IP address
    range dynamic-bootp 10.2.1.2 10.2.1.200;
    # specify broadcast address
    option broadcast-address 10.2.0.255;
    # specify gateway
}
```

```

[yaniss@node1 ~]$ ip a
[...]
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:20:59:0f brd ff:ff:ff:ff:ff:ff
    inet 10.2.1.2/24 brd 10.2.1.255 scope global dynamic noprefixroute enp0s8
[...]
```
```

[yaniss@node1 ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=61 time=53.0 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=61 time=55.3 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 53.020/54.136/55.253/1.140 ms
```
```

[yaniss@node1 ~]$ ip r
default via 10.2.1.254 dev enp0s8 proto dhcp metric 100
```
```

[yaniss@node1 ~]$ dig
;; SERVER: 1.1.1.1#53(1.1.1.1)
```


### 2. Analyse de trames

🌞**Analyse de trames**
| ordre | type trame   | IP source | MAC source                 | IP destination | MAC destination            |
|-------|--------------|-----------|----------------------------|----------------|----------------------------|
| 1     | ARP Request| 10.2.1.11   |  `08:00:27:00:76:a1`| 255.255.255.255|`ff:ff:ff:ff:ff:ff`|
| 2     | ARP Reply  | 0.0.0.0 | `08:00:27:20:59:0f` | 10.2.1.11     |`08:00:27:00:76:a1`|
| 3     | DHCP Discover    | 0.0.0.0  | `08:00:27:20:59:0f`| 255.255.255.255    |`ff:ff:ff:ff:ff:ff`| |
| 4     | DHCP Offer   | 10.2.1.11 | `08:00:27:00:76:a1` | 10.2.1.3     |`08:00:27:20:59:0f` |
| 5     | DHCP Request | 0.0.0.0   | `08:00:27:20:59:0f` | 255.255.255.255|Broadcast`ff:ff:ff:ff:ff:ff`|
| 6     | DHCP Ack     | 10.2.1.11 | `08:00:27:00:76:a1` | 10.2.1.3      |`08:00:27:20:59:0f` |


