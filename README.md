# TP1_GitHub

# TP1 - Mise en jambes
## I. Exploration locale en solo

### 1. Affichage d'informations sur la pile TCP/IP locale

#### - Affichez les infos des cartes réseau de votre PC
Avec la commande je peux lister tous mes cartes reseaux
```
\sbin\ifconfig 
```
```
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether 8c:85:90:0d:0d:96
	inet6 fe80::c21:edc2:3bb2:fbc1%en0 prefixlen 64 secured scopeid 0x5
	inet 10.33.2.197 netmask 0xfffffc00 broadcast 10.33.3.255
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active
```
Ma carte WIFI se nomme en0 son adresse mac est 8c:85:90:0d:0d:96 et son IP est 10.33.2.197

Je n'ai cependant pas de carte ETHERNET sur mon mac car je n'en ai pas branché.


#### Affichez votre gateway
Avel la commande suivante
```
route get default | grep gateway
```

```
gateway: 10.33.3.253
```
L'IP de la gateway de ma carte WIFI est 10.33.2.197

### En graphique (GUI : Graphical User Interface)

#### trouvez comment afficher les informations sur une carte IP (change selon l'OS)

Ces informations se trouvent dans SystemesPreferences/Network

Adresse Mac WIFI = 8c:85:90:0d:0d:96
Adresse IP = 10.33.3.255
Adresse de la gateway = 10.33.3.253

### Questions ?
####  à quoi sert la gateway dans le réseau d'YNOV ?

La gateway permet de relier deux réseaux informatiques. Ici chez Ynov la gateway permet de faire communiquer le réseau de d'Ynov avec Internet

## 2. Modifications des informations

#### Utilisez l'interface graphique de votre OS pour changer d'adresse IP :

Sur MacOs pour changer manuellement l'IP de sa carte WIFI il faut aller dans Preferences/Network/Advanced/TCI-IP puis cliquer sur changer manuellement a la place de DHCP.
Ensuite on peut changer ladresse du IP de la carte WIFI. 
Ancienne IP: 10.33.2.197
Nouvelle IP: 10.33.2.17
(en laissant le meme subnet mask)

#### Il est possible que vous perdiez l'accès internet expliquer pourquoi ? :

Il est en effet possible que l'on perde la connection a internet. Ceci peut arriver par exemple si une autre persnonne partage la meme adresse IP que nous.

### B. Table ARP

#### Exploration de la table ARP
 Avec la commande suivante j'affiche ma table ARP
 ```
 arp -a
 ```
 ```
? (10.33.1.41) at 9c:fc:e8:36:7b:ee on en0 ifscope [ethernet]
? (10.33.1.231) at 40:ec:99:f3:3e:14 on en0 ifscope [ethernet]
? (10.33.2.250) at 5c:3a:45:6:7a:5f on en0 ifscope [ethernet]
? (10.33.3.253) at 0:12:0:40:4c:bf on en0 ifscope [ethernet]
? (224.0.0.251) at 1:0:5e:0:0:fb on en0 ifscope permanent [ethernet]
? (239.255.255.250) at 1:0:5e:7f:ff:fa on en0 ifscope permanent [ethernet] 
```

On peut facilement reperer l'adresse mac de la gateway de la WIFI d'Ynov avec son adresse IP
(10.33.3.253) 0:12:0:40:4c:bf

#### Et si on remplissait un peu la table ?

Avec la commande ping, j'ai pu communiquer avec des clients de mon réseau. Pour rapel l'adresse reseau du resau d'YNOV est 10.33.0.0
donc je ping 10.33.1.76, 10.33.1.103 et 10.33.2.8

Je réaffche ma table ARP et je trouve les adresses MAC correspondantes.

```
? (10.33.1.76) at e0:cc:f8:7a:4f:4a on en0 ifscope [ethernet]
? (10.33.1.103) at 18:65:90:ce:f5:63 on en0 ifscope [ethernet]
? (10.33.2.8) at a4:5e:60:ed:b:27 on en0 ifscope [ethernet]
```

Donc l'IP 10.33.1.76 a pour MAC e0:cc:f8:7a:4f:4
Donc l'IP 10.33.1.103 a pour MAC 18:65:90:ce:f5:63
Donc l'IP 10.33.2.8 a pour MAC a4:5e:60:ed:b:27

### C. nmap

#### Utilisez nmap pour scanner le réseau de votre carte WiFi et trouver une adresse IP libre
```
nmap -sP 10.33.0.0/24
```
```
Starting Nmap 7.92 ( https://nmap.org ) at 2021-09-13 12:35 CEST
Nmap scan report for 10.33.0.57
Host is up (0.097s latency).
Nmap scan report for 10.33.0.85
Host is up (0.071s latency).
Nmap scan report for 10.33.0.95
Host is up (0.012s latency).
Nmap scan report for 10.33.0.117
Host is up (0.086s latency).
Nmap scan report for 10.33.0.143
Host is up (0.073s latency).
Nmap scan report for 10.33.0.226
Host is up (0.0092s latency).
Nmap done: 256 IP addresses (6 hosts up) scanned in 48.05 seconds
```


Je réaffiche mon table ARP avec toutes les nouvelles connexions effectues avec nmap.

```
arp -a 
```
```
? (10.33.0.0) at ff:ff:ff:ff:ff:ff on en0 ifscope [ethernet]
? (10.33.0.1) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.2) at dc:f5:5:ce:ec:f7 on en0 ifscope [ethernet]
? (10.33.0.3) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.4) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.5) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.6) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.7) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.8) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.9) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.10) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.11) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.12) at (incomplete) on en0 ifscope [ethernet]
? (10.33.0.13) at d2:50:e:26:94:8b on en0 ifscope [ethernet]
[...]
```
Le retour de la commande est tres long compte tenu du fait de tous les connexions effectues par nmap afin de trouver une adresse libre.

### D. Modification d'adresse IP (part 2)

J'utilise la commande nmpa pour connaitre les IP libres su mon réseau.
```
nmap -sP 10.33.0.0/24
```
```
Starting Nmap 7.92 ( https://nmap.org ) at 2021-09-13 12:44 CEST
Nmap scan report for 10.33.0.13
Host is up (0.11s latency).
Nmap scan report for 10.33.0.57
Host is up (0.026s latency).
Nmap scan report for 10.33.0.85
Host is up (0.023s latency).
Nmap scan report for 10.33.0.95
Host is up (0.0067s latency).
Nmap scan report for 10.33.0.111
Host is up (0.099s latency).
Nmap scan report for 10.33.0.117
Host is up (0.069s latency).
```

Je choisis l'adresse libre sur le réseau 10.33.0.95


Je reproduis les étapes précedentes pour changer manuellelement mon adresse ip.
Ancienne IP: 10.33.2.197
Nouvelle IP: 10.33.0.95

Avec la commande suivante je verifie la passerelle.
```
route get default | grep gateway
```

```
gateway: 10.33.3.253
```
Je verifie ma connexion Internet.
```
ping 8.8.8.8
```

PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: icmp_seq=0 ttl=115 time=18.848 ms
64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=19.186 ms

## 3. Modification d'adresse IP

Ne possédant pas de ports Ehternet j'ai créer un hotspot (Wifi) avec mon iPhone afin que l'on puisse en se connectant dessus etre dans le meme réseau.

L'adresse de la gateway est 172.20.10.1 obtenu avec la commande route get default | grep gateway
Mon IP est 172.20.10.3 et l'IP de Aranud est 172.20.10.7. On peut vérifier si l'on peut communiquer entre nous avec la commande ping.
```
$ping -c 2 172.20.10.7
PING 172.20.10.7 (172.20.10.7): 56 data bytes
64 bytes from 172.20.10.7: icmp_seq=0 ttl=64 time=7.846 ms
64 bytes from 172.20.10.7: icmp_seq=1 ttl=64 time=164.429 ms


$arp -a
? (172.20.10.1) at ba:5d:a:97:d1:64 on en0 ifscope [ethernet]
? (172.20.10.3) at 8c:85:90:d:d:96 on en0 ifscope permanent [ethernet]
? (172.20.10.7) at 14:7d:da:1e:77:a4 on en0 ifscope [ethernet]
? (172.20.10.15) at ff:ff:ff:ff:ff:ff on en0 ifscope [ethernet]
? (224.0.0.251) at 1:0:5e:0:0:fb on en0 ifscope permanent [ethernet]
? (239.255.255.250) at 1:0:5e:7f:ff:fa on en0 ifscope permanent [ethernet]
```
On remarque donc l'IP d'Arnaud (172.20.10.7) dans la table ARP.

## 5. Petit chat privé

En tant que serveur je lance la commande suivante:
```
nc -l 8888
```
J'ecoute donc sur le port 8888.
 Voici le résultat de notre petit chat 

 ```
$nc -l 8888
ta mere est tellement grosse que tout le monde la refuse à mcdo
ta mere est tellement grosse que cette blague va être trop longue pour elle
ta mere est tellement grosse qu'elle a une telcommande pour sa telecommande
```

#### 🌞 pour aller un peu plus loin

Je précise l'adresse sur laquelle ecouter.
```
$nc -l 172.20.10.3 8888
```

Arnaud peut donc bien communiquer avec moi sur 172.20.10.3 avec le port 172.20.10.3.

On peut aussi accepter uniquement les connexions internes à la machine.
Je lance deux terminals et j'execute les commandes suivantes.

TTY1
```
$nc localhost 8888
qwdwqd
wqdwqd
qwdwqd
qwdq
```

TTY2
```
$nc -l localhost 8888
qwdwqd
wqdwqd
qwdwqd
qwdq
```

## 6. Firewall

Dans mes préférences sytemes je configure le firewall pour désactiver le mode furtif qui n'autorise pas les tentatives d'acces via le protocole ICMP.
Je peux donc ping n'importe quel device sur mon réseau.
```
$ping -c 2 172.20.10.7
PING 172.20.10.7 (172.20.10.7): 56 data bytes
64 bytes from 172.20.10.7: icmp_seq=0 ttl=64 time=7.846 ms
64 bytes from 172.20.10.7: icmp_seq=1 ttl=64 time=164.429 ms
```

# III. Manipulations d'autres outils/protocoles côté client
## 1. DHCP

Pour avoir les informations relatives a mon serveur (DHCP).
```
$ipconfig getpacket en0
[...]
server_identifier (ip): 10.33.3.254
lease_time (uint32): 0x1c20
[...]
```
Avec ces informations on peut donc trouver l'IP du serveur (DHCP) : 10.33.3.254
Et le temps d'expiration du bail. ox1c20(hexadecimales)=7200s=2h

# 2. DNS

Les adresses IP des serveurs dns se trouvent avec la commande suivantes 
```
$scutil --dns | grep 'nameserver\[[0-9]*\]'
nameserver[0] : 10.33.10.2
nameserver[1] : 10.33.10.148
nameserver[2] : 10.33.10.155
```

Avec la commande nslookup je trouve l'IP de google.com et celle de ynov.com.

```
$nslookup google.com
Server:		10.33.10.2
Address:	10.33.10.2#53

Non-authoritative answer:
Name:	google.com
Address: 142.250.75.238

$nslookup ynov.com
Server:		10.33.10.2
Address:	10.33.10.2#53

Non-authoritative answer:
Name:	ynov.com
Address: 92.243.16.143
```

Les adresses de google et de ynov 142.250.75.238 et 92.243.16.143 resolus avec le serveur DNS qui a pour IP 10.33.10.2.

Et avec le reverse lookup  on remarque que l'adresse 78.74.21.21 a pour nom de domaine homerun.telia.com et l'adresse 92.146.54.88 a pour nom de domaine abo.wanadoo.fr.
$ nslookup 78.74.21.21
Server:		10.33.10.2
Address:	10.33.10.2#53

Non-authoritative answer:
21.21.74.78.in-addr.arpa	name = host-78-74-21-21.homerun.telia.com.


$ nslookup 92.146.54.88
Server:		10.33.10.2
Address:	10.33.10.2#53

Non-authoritative answer:
88.54.146.92.in-addr.arpa	name = apoitiers-654-1-167-88.w92-146.abo.wanadoo.fr.

# 6. WireShark

Je ping 8.8.8.8 pour voir les trames sur WireShark pour tester un ping entre moi et ma passerelle.

![Screenshot](/Users/yanissloisel/Desktop/ReseauB2/TP1_GitHub/Image1.png)
