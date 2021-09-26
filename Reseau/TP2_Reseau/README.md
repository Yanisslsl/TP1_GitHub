# TP2 : On va router des trucs

## I. ARP

### 1. Echange ARP
Pour rappel les IP de mes VM sont 10.2.1.12 et 10.2.1.11
Je ping donc 10.2.1.12 depuis ma VM1(10.2.1.11)

```
[yaniss@bastion-ovh1fr ~]$ ping 10.2.1.12
PING 10.2.1.12 (10.2.1.12) 56(84) bytes of data.
64 bytes from 10.2.1.12: icmp_seq=1 ttl=64 time=1.04 ms
64 bytes from 10.2.1.12: icmp_seq=2 ttl=64 time=0.540 ms
64 bytes from 10.2.1.12: icmp_seq=3 ttl=64 time=0.423 ms
```

Idem depuis ma VM2
```
[yaniss@bastion-ovh1fr ~]$ ping 10.2.1.11
PING 10.2.1.11 (10.2.1.11) 56(84) bytes of data.
64 bytes from 10.2.1.11: icmp_seq=1 ttl=64 time=0.372 ms
64 bytes from 10.2.1.11: icmp_seq=2 ttl=64 time=0.359 ms
```

J'affiche ma table ARP sur ma VM1.

[yaniss@bastion-ovh1fr ~]$ ip neigh show
10.2.1.1 dev enp0s8 lladdr 0a:00:27:00:00:02 DELAY
10.2.1.12 dev enp0s8 lladdr 08:00:27:ff:5b:ea REACHABLE
10.0.2.2 dev enp0s3 lladdr 52:54:00:12:35:02 STALE

.. et sur ma vm2
```
[yaniss@bastion-ovh1fr ~]$ ip neigh show
10.2.1.11 dev enp0s8 lladdr 08:00:27:ac:ad:4c STALE
10.2.1.1 dev enp0s8 lladdr 0a:00:27:00:00:02 REACHABLE
10.0.2.2 dev enp0s3 lladdr 52:54:00:12:35:02 STALE
```
 D'apres les infos ci-dessus ma VM1(10.2.1.11) a pour MAC 08:00:27:ac:ad:4c et ma VM2(10.2.1.12) a pour MAC 08:00:27:ac:ad:4c.

Je peux donc ensuite vérifier les adresses mac avec la commande ip a.

```
$ip a
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:ff:5b:ea brd ff:ff:ff:ff:ff:ff
    inet 10.2.1.12/24 brd 10.2.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feac:ad4c/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

Sur ma VM2(10.2.1.12) l'adresse MAC correspondante a mon interface enp0s8 est 08:00:27:ff:5b:ea ce qui valide bien les informations trouvées avec ma table ARP
Sur ma VM1(10.2.1.11) l'adresse MAC correspondante a mon interface enp0s8 est 08:00:27:ac:ad:4c ce qui valide bien les informations trouvées avec ma table ARP


### 2. Analyse de trames
|ordre | type trame | source                  | destination              |
|------|------------|-------------------------|--------------------------|
|  1   | Requête ARP| node2 08:00:27:74:ef:11 | Broadcast FF:FF:FF:FF:FF |
|  2   | Réponse ARP| node1 08:00:27:ff:5b:ea | node2 08:00:27:74:ef:11  |



