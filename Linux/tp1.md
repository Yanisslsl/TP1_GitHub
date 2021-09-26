# TP1 LINUX

## 🌞 Setup de deux machines Rocky Linux configurée de façon basique.

#### un accès internet

Avec la commande ip a j'affiche les cartes réseaux de ma machine.
‘‘‘
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:ac:c7:57 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 86350sec preferred_lft 86350sec
    inet6 fe80::a00:27ff:feac:c757/64 scope link noprefixroute
       valid_lft forever preferred_lft foreve
‘‘‘
Cette carte reseau est réservé a ma Nat qui pointe vers mon routeur 


Avec la commande ip r j'affiche ma route par défaut qui passe par la carte réservé  a la NAT
‘‘‘
default via 10.0.2.2 dev enp0s3 proto dhcp metric 100
‘‘‘

#### un accès à un réseau local (les deux machines peuvent se ping

Avec les deux nouvelles interfaces réseaux sur les deux machines avec les commandes suivantes: nmcli con up <nom de la carte>,
je peux essayer de ping mes machines virtuelles.

‘‘‘
[yaniss@bastion-ovh1fr root]$ ping -c 2 10.101.1.12
PING 10.1.1.12 (10.1.1.12) 56(84) bytes of data.
64 bytes from 10.1.1.12: icmp_seq=1 ttl=64 time=0.940 ms
64 bytes from 10.1.1.12: icmp_seq=2 ttl=64 time=0.568 ms
‘‘‘

‘‘‘
[yaniss@bastion-ovh1fr root]$ ping -c 2 10.101.1.11
PING 10.1.1.11 (10.1.1.11) 56(84) bytes of data.
64 bytes from 10.1.1.11: icmp_seq=1 ttl=64 time=0.583 ms
64 bytes from 10.1.1.11: icmp_seq=2 ttl=64 time=0.463 ms
‘‘‘


Voici les cartes réseaux dédiées de mes machines.
[yaniss@bastion-ovh1fr root]$ ip a
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:ce:d8:9b brd ff:ff:ff:ff:ff:ff
    inet 192.168.120.14/24 brd 192.168.120.255 scope global dynamic noprefixroute enp0s8
       valid_lft 330sec preferred_lft 330sec
    inet6 fe80::a00:27ff:fece:d89b/64 scope link noprefixroute
       valid_lft forever preferred_lft forever

[yaniss@bastion-ovh1fr root]$ ip a
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:ce:d8:9b brd ff:ff:ff:ff:ff:ff
    inet 192.168.120.13/24 brd 192.168.120.255 scope global dynamic noprefixroute enp0s8
       valid_lft 330sec preferred_lft 330sec
    inet6 fe80::a00:27ff:fece:d89b/64 scope link noprefixroute
       valid_lft forever preferred_lft forever

#### les machines doivent avoir un nom

Je modifie les fichiers /etc/hostname sur mes machines pour modifier le nom de domaine de mes hotes avec les commandes suivantes
‘‘‘
echo 'node1.tp1.b2' | sudo tee /etc/hostname
echo 'node2.tp1.b2' | sudo tee /etc/hostname
‘‘‘

#### utiliser 1.1.1.1 comme serveur DNS

Je change le contenu du fichier /etc/reslov.conf en y ajoutant nameserver 1.1.1.1
Puis je test la résolution DNS avec dig ynov.com
La commande me renvoit une reponse du serveur d'Ynov avec server DNS utilisé 1.1.1.1 et comme ip 92.243.16.143 poyr l'adresse ynov.com  
‘‘‘
;; SERVER: 1.1.1.1#53(1.1.1.1)

;; ANSWER SECTION:
ynov.com.		9842	IN	A	92.243.16.143
‘‘‘


#### les machines doivent pouvoir se joindre par leurs noms respectifs

Je modifie les fichiers /etc/hosts pour faire correspondre les ips de mes VMS et les hostname. avec la commande suivante sudo nano /etc/hosts.

[root@bastion-ovh1fr ~]# ping VM_1
PING VM_1 (10.1.1.11) 56(84) bytes of data.
64 bytes from VM_1 (10.1.1.11): icmp_seq=1 ttl=64 time=0.411 ms


[root@bastion-ovh1fr ~]# ping VM_2
PING VM_2 (10.1.1.11) 56(84) bytes of data.
64 bytes from VM_2 (10.1.1.11): icmp_seq=1 ttl=64 time=0.048 ms5


### le pare-feu est configuré pour bloquer toutes les connexions exceptées celles qui sont nécessaires

Avec la commande firewall-cmd --list-all je consulte les regles de configuration de mon firewall.

$sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules

Je vois bien qu'il est actif et que les services autorisés sont ssh par exmple.

Avec la commande useradd superme -m -s /bin/sh -u 2000 je creer  mon user en lui precisant de creer son propre Home Directory et avec /bin/sh comme shell par defaut.

J'ajoute ensuite le goup admins avec la commande groupadd admins.

Par la suite on je modifie le fichier sudo visudo /etc/sudoers en y ajoutant la ligne %admins ALL=(ALL)       ALL.

Enfin je peux ajouter l'user au groupe admins avec la commande usermod -aG admins superme.

Pour verifier si l'user est bien dans le groupe admins je verifie dans quel group est superme avec la commande groups.
‘‘‘
$ groups superme
superme : superme admins
‘‘‘

Et je verifie dans sudoers si le groupe admins a bien les droits privileges 
‘‘‘

$ cat /etc/sudoers

[...]
## Allows people in group wheel to run all commands
%wheel	ALL=(ALL)	ALL
%admins ALL=(ALL)       ALL
[...]
‘‘‘


### 2. SSH

Je commence donc par generer ma cle publique sur mon appreil hote avec la commande suivante>
‘‘‘
yanissloisel@mbp-de-yaniss  ~  ssh-keygen -t rsa -b 4096
‘‘‘

La clé publique est genere donc dans le fichier /Users/yanissloisel/.ssh/id_rsa.

Avec la commande scp je copie donc le fichier dans le dossier home de l'utilsateur crée sur ma VM.
‘‘‘
scp /Users/yanissloisel/.ssh/id_rsa.pub superme@10.101.1.11:/home/superme
‘‘‘

Sur ma VM, connécté avec l'user superme je copie le creer mon dossier .ssh (avec mkdir .ssh) et je copie la clé publique dans le fichier /home/superme/.ssh/authorized_keys.
‘‘‘
cp /home/superme/id_rsa.pub /home/superme/.ssh/authorized_keys
‘‘‘

Je vérifie que mon fichier a bien été collé.
‘‘‘
cat /home/superme/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDomzaW99qE/zLEcBtIGdqZQWwa09BevKpmD23rb5WwozNg1SSf+OdyTtf+H7f/9Cxp47wMC8B5v36LJI59VddxnUxrIkct9o6RkJHkSpTUhIhSv8LiTbvcMh//e8/jl/ziDv0vAK+mz2U+rhCFACGnLHPnZin/oBNXchvkWzM8+QQMe1ALOgrPY30FaCb2icV5ZFU9/wFya4DlpulzdZ34PySZxyJ6Ez8qLVeV+YG+JI3O5LQAqTbsi4W2Jr4bGl2z2CdKZXOdto+jKmKvVZ9pQJFrJrdaD1OJt3AV7h8QC/0fpLPYuCPrsoZQHaKrOYwcej0j78YWumaZ7jOAgx00nzwowqoTbIma0hFCAfKehBJ7qGTEZ9bLlg+3BttKalXRgjCXVnymwyd2tS2v89zna743cmYwzjTnWnPW1OkvdffzMPKgZo/vSxYEJNV16PZLOMXD4j96XU2QFj659CxipdZXu84oRdvO9AnEQhwllV/Yst4+myeXt7kZWkTZgGuzndRZVUGjU6RKymVWj5fv5ZcMFsY/kIT093Ngo2o8Y2bVq7dW8sAJswYh2V7Mi50PCb98poD+cB7Nhcz8DCz89bXm3rzkEtgL0SpTARW0MqrTDni8u38kWykOpaRejpdZ/n+TWUFtxpn/zrVavnyQL1WihLL5nVHvhH8E+xz1Aw== yanissloisel@MacBook-Pro-de-Yaniss.local
‘‘‘

Je donne les droits suivants au fichier et au dossier suivants.
‘‘‘
$ chmod 600 /home/superme/.ssh/authorized_keys
$ chmod 700 /home/superme/.ssh
‘‘‘


Enfin depuis mon hote je verifie ma connexion SSH (sans avoir besoin du mot de passe de l'utilsateur)
‘‘‘
✘ yanissloisel@mbp-de-yaniss  ~  ssh superme@10.101.1.11
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Sun Sep 26 16:20:43 2021 from 10.101.1.1
‘‘‘


# II.Partionnement 

Dans le menu configuration de VBox je modifie l'espace de stockage en y ajoutant deux disques VDI de 3G chacun.
Je verifie la presence de mes disques avec la commade lsblk.

‘‘‘
[superme@node1 ~]$ lsblk
NAME                        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                           8:0    0    8G  0 disk
├─sda1                        8:1    0    1G  0 part /boot
└─sda2                        8:2    0    7G  0 part
  ├─rl_bastion--ovh1fr-root 253:0    0  6,2G  0 lvm  /
  └─rl_bastion--ovh1fr-swap 253:1    0  820M  0 lvm  [SWAP]
sdb                           8:16   0    3G  0 disk
sdc                           8:32   0    3G  0 disk
‘‘‘
Tout d'abord je creer les volumes physiques avec les commandes pvcreate pour les volumes sdb et sdc. Et je verifie la presence de ces volumes physiques avec la commande suivante.
‘‘‘
[superme@node1 ~]$ sudo pvs
  PV         VG                Fmt  Attr PSize  PFree
  /dev/sda2  rl_bastion-ovh1fr lvm2 a--  <7,00g    0
  /dev/sdb                     lvm2 ---   3,00g 3,00g
  /dev/sdc
‘‘‘


Je crée le volume group en choisissant le volume physique /dev/sdb.
‘‘‘
[superme@node1 ~]$ sudo vgcreate data /dev/sdb
  Volume group "data" successfully created
‘‘‘


‘‘‘

Puis j'y ajoute le volume physique /dev/sdb
[superme@node1 ~]$ sudo vgextend data /dev/sdc
  Volume group "data" successfully extended
‘‘‘

Avec la commande suivante je verifie mon volume group(avec normalement la taille de 6G)
‘‘‘
[superme@node1 ~]$ sudo vgs
  VG                #PV #LV #SN Attr   VSize  VFree
  data                2   0   0 wz--n-  5,99g 5,99g
  rl_bastion-ovh1fr   1   2   0 wz--n- <7,00g    0
‘‘‘

Ensuite je crée le volume logique.
‘‘‘

[superme@node1 ~]$ sudo lvcreate -L 5.99G data -n logicaldata
  Rounding up size to full physical extent 5,99 GiB
  Logical volume "logicaldata" created.
‘‘‘

Et je vérifie avec la commande suivante.

[superme@node1 ~]$ sudo lvs
  LV          VG                Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  logicaldata data              -wi-a-----   5,99g
  root        rl_bastion-ovh1fr -wi-ao----  <6,20g
  swap        rl_bastion-ovh1fr -wi-ao---- 820,00m

  Pour que cette partition soit montée automatiquement je modifie le fichier /etc/fstab en y ajoutant la ligne.
‘‘‘

   /dev/data/logicaldata /mnt/data1 ext4 defaults 0 0
‘‘‘

Puis je reboot pour vérifier. Et je remarque bien l'existence du dossier data1 dans /mnt/.

# III. Gestion des services 

Je m'assure que le service firewalld est actif et automatiquement actif au démarrage.
‘‘‘

[superme@node1 ~]$ systemctl is-active firewalld.service
active
[superme@node1 ~]$ systemctl is-enabled firewalld.service
enabled
‘‘‘

## 2 Création de Services 

### A.Unité simpliste 

Je crée le fichier web.service dans /etc/systemd/system en y ajoutant le contenu suivant.

[Unit]
Description=Very simple web service

[Service]
ExecStart=/bin/python3 -m http.server 8888

[Install]
WantedBy=multi-user.target

Je redemarre le service avec: sudo systemctl daemon-reload

Puis je vérifie le status du service en vérifiant qu'il est actif.
‘‘‘

[superme@node1 system]$ sudo systemctl status web
● web.service - Very simple web service
   Loaded: loaded (/etc/systemd/system/web.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2021-09-26 18:51:16 CEST; 7s ago
[...]
‘‘‘


Avec un simple curl je verifie que le serveur Web est bien accessible sur le port 8888.
‘‘‘

 ✘ yanissloisel@mbp-de-yaniss  ~ curl localhost:8888
 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
[...]
</ul>
<hr>
</body>
</html>
‘‘‘


