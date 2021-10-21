# TP4 : Vers un réseau d'entreprise

## I. Dumb switch

### 3. Setup Topologie 1

#### 🌞 Adressage

PC2> ip 10.1.1.1  

PC2> show ip 

NAME        : PC2[1]
IP/MASK     : 10.1.1.1/24
GATEWAY     : 0.0.0.0
DNS         : 
MAC         : 00:50:79:66:68:01
LPORT       : 20002
RHOST:PORT  : 127.0.0.1:20037
MTU         : 1500



PC1> show ip

NAME        : PC1[1]
IP/MASK     : 10.1.1.2/24

Depuis 10.1.1.2 je ping 10.1.1.1

PC1> ping 10.1.1.1

84 bytes from 10.1.1.1 icmp_seq=1 ttl=64 time=14.600 ms
84 bytes from 10.1.1.1 icmp_seq=2 ttl=64 time=4.388 ms

#### 🌞 Configuration des VLANs

Switch#show vlan br 

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Gi0/2, Gi0/3, Gi1/0, Gi1/1
                                                Gi1/2, Gi1/3, Gi2/0, Gi2/1
                                                Gi2/2, Gi2/3, Gi3/0, Gi3/1
                                                Gi3/2, Gi3/3
10   10                               active    Gi0/0, Gi0/1
20   20                               active    Gi0/2

### 🌞 Vérif

PC1> ping 10.1.1.1

84 bytes from 10.1.1.1 icmp_seq=1 ttl=64 time=7.744 ms
84 bytes from 10.1.1.1 icmp_seq=2 ttl=64 time=5.373 ms

PC2> ping 10.1.1.2

84 bytes from 10.1.1.2 icmp_seq=1 ttl=64 time=5.733 ms
84 bytes from 10.1.1.2 icmp_seq=2 ttl=64 time=3.492 ms

PC3> ping 10.1.1.1

host (10.1.1.1) not reachable



## III. Routing


