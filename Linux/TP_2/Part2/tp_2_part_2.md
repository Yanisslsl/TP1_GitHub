# TP2 pt. 2 : Maintien en condition opérationnelle

### 🌞 Manipulation du service Netdata
```
[yaniss@web ~]$ systemctl is-enabled netdata
enabled
```
```
[yaniss@web ~]$ ss -lta
LISTEN      0       128                 0.0.0.0:19999              0.0.0.0:*
```
```
[yaniss@web ~]$ sudo firewall-cmd --add-port=19999/tcp --permanent

```
### 🌞 Setup Alerting

J'execute la commande suivante 
```
[yaniss@web ~]$sudo /opt/netdata/etc/netdata/edit-config health_alarm_notify.conf
```
Et je modifie la lgine suivante en collant l'url du webhook copié depuis Discord.

# Create a webhook by following the official documentation -
# https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks



Puis dans le bash netdata j'execute la commande suivante.
```
bash-4.4$ /opt/netdata/usr/libexec/netdata/plugins.d/alarm-notify.sh test
```
Et je remarque la reception de messages d'alertes dans le serveur Discord.

Je creer le fichier suivant netdata/health.d.
```
[yaniss@web health.d]$ cat ram-usage.conf
 alarm: ram_usage
    on: system.ram
lookup: average -1m percentage of used
 units: %
 every: 1m
  warn: $this > 50
  crit: $this > 50
  info: The percentage of RAM being used by the system.
  ```
 Je restart le service et avec la commande stress je diminue l'espace libre sur ma RAM.
 
 [yaniss@web health.d]$ stress -m 1 --vm-bytes 3000M --vm-keep (Pour rappel ma VM dispose de 3.5 GO d'espace)
 
 Apres seulement 1 minute, j'ai bien recu des alertes sur Discord avec comme titre "ram in use = 94.8%"
 
 
 # 2. Partage NFS
 
 On ajoute un nom domaine dans le fichier suuvant.
  ```
 
 [yaniss@web web.tp2.linux]$ sudo nano /etc/idmapd.conf
  ```
 
 On ajoute ensuite une ip autorisé
  ```
 
 [yaniss@web web.tp2.linux]$ sudo cat /etc/exports
 /srv/backups/web.tp2.linux 10.3.0.126/25(rw,no_root_squash)
  ```
 
 On autorise ensuite le service nfs dans le firewall.
 
Sur le client on installe les packages utiles pour l'installation du service nfs on créer ensuite le dossier /srv/backup.

On monte ensuite le bon dossier sur le client 
  ```

[yaniss@web backup]$ sudo mount -t nfs 10.3.0.123:/srv/backups/web.tp2.linux /srv/backup/
  ```
Je teste en créant un fichier 
  ```

[yaniss@web web.tp2.linux]$ sudo touch toto
  ```
 
Le dossier est bien présent.
  ```

[yaniss@web backup]$ ls
toto
  ```
 
# 3. Backup de fichiers

J'execute le script sur la vm web.
  ```

[yaniss@web srv]$ sudo ./tp2_backup.sh /srv/backup ~/lolo
[OK] Archive /srv/tp2_backup_211025_100236.tar.gz created.
[OK] Archive /srv/tp2_backup_211025_100236.tar.gz synchronized to /srv/backup.
[OK] Directory /srv/backup cleaned to keep only the 5 most recent backups.
  
 
  ```
  Le dossier est tar est bien present dans le dossier /srv/backups, on verifie sur la vm de backup si le fichier est bien present dans /srv/backups/web.tp2.linux.
  ```
  
 [yaniss@web backup]$ ls
hello_211025_100236.tar.gz  tata  toto
  ```
  On remarque que le fichier est bien present dans /srv/backups/web.tp2.linux.
  ```
 
 [yaniss@web web.tp2.linux]$ ls
hello_211025_100236.tar.gz  tata  toto
  ```
  
  On peut ensuite avoir acces au fichier en le decompressant.
  
  ```
  
  [yaniss@web ~]$ sudo tar -xvf /srv/backups/web.tp2.linux/hello_211025_100236.tar.gz
home/yaniss/lolo
  ```
### 4. Unité de service.

Dans le dossier /etc/systemd/system/ je creer mon fichier de configuration du service. Une fois cela fait je le démarre. Et je verifie que le fichier tar est present dans mon autre VM.
  ```

[yaniss@web web.tp2.linux]$ ls -al
total 20
drwxr-xr-x. 3 root root 188 25 oct.  10:46 .
drwxr-xr-x. 3 root root  27 24 oct.  15:31 ..
-rw-r--r--. 1 root root 124 25 oct.  10:31 tp2_backup_211025_103148.tar.gz


  ```

Jai redemarré plusieurs fois le service d'ou la presence de plusiseurs fichiers tar.

## B.Timer

Pareil que pour la partie A je creer le service dans le dossier  /etc/systemd/system/.
Puis j'enable le service et je verifie qu'il le soit.

  ```

[yaniss@web system]$ systemctl is-enabled tp2_backup.timer
enabled
  ```
Je verifie que le service soit actif.
  ```

[yaniss@web ~]$ sudo systemctl status tp2_backup.timer
[sudo] Mot de passe de yaniss :
● tp2_backup.timer - Periodically run our TP2 backup script
   Loaded: loaded (/etc/systemd/system/tp2_backup.timer; enabled; vendor preset: disabled)
   Active: active (waiting) since Mon 2021-10-25 11:05:33 CEST; 22s ago
  Trigger: Mon 2021-10-25 11:06:00 CEST; 3s left

oct. 25 11:05:33 web.tp2.linux systemd[1]: Started Periodically run our TP2 backup script.
  ```
On remarque donc la creation d'un nouveau fichier tar dans dans la VM.


## C.Contexte

On remarque bien que le service s'executera a 3:15.
  ```

[yaniss@web system]$ sudo systemctl list-timers
NEXT                          LEFT       LAST                          PASSED      UNIT                         ACTIVATES
Mon 2021-10-25 11:20:26 CEST  6min left  n/a                           n/a         systemd-tmpfiles-clean.timer systemd-tmpfile>
Mon 2021-10-25 12:03:13 CEST  49min left n/a                           n/a         dnf-makecache.timer          dnf-makecache.s>
Tue 2021-10-26 03:15:00 CEST  16h left   Mon 2021-10-25 11:13:03 CEST  1min 8s ago tp2_backup.timer             tp2_backup.serv>
  ```
  
  # 5.Backup de la base de données.
  
  
  
  III. Reverse Proxy 
  
  J'installe nginx et epel-release.
  Je lance nginx et je verifie qu'il soit enabled.
  ```
  
[yaniss@web ~]$ systemctl is-enabled nginx
enabled
  ```
Le port par defaut de nginx est le port 80 (facilement trouvable avec curl localhost:80)
  ```

[yaniss@web ~]$ curl localhost
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
[...]
  ```
  
 ### Exploration et modification de la conf NGinx
  ```
 
 [yaniss@web ~]$ sudo cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.101.1.11  web.tp2.linux
  ```

  ```

[yaniss@web ~]$ sudo cat /etc/nginx/conf.d/web.tp2.linux.conf
server {
    # on demande à NGINX d'écouter sur le port 80 pour notre NextCloud
    listen 80;

    # ici, c'est le nom de domaine utilisé pour joindre l'application
    # ce n'est pas le nom du reverse proxy, mais le nom que les clients devront saisir pour atteindre le site
    server_name web.tp2.linux; # ici, c'est le nom de domaine utilisé pour joindre l'application (pas forcéme

    # on définit un comportement quand la personne visite la racine du site (http://web.tp2.linux/)
    location / {
        # on renvoie tout le trafic vers la machine web.tp2.linux
        proxy_pass http://web.tp2.linux;
    }
}
  ```


## IV.Firewalling
  ```

[yaniss@db ~]$ sudo firewall-cmd --get-active-zones
db
  sources: 10.101.1.11/24
drop
  interfaces: enp0s3
  ```
  ```

[yaniss@web ~]$ sudo firewall-cmd --get-active-zones
drop
  interfaces: enp0s3
web
  sources: 10.101.1.14/24
  ```
  ```


[yaniss@web ~]$ sudo firewall-cmd --get-active-zones
backup
  sources: 10.101.1.11/24 10.101.1.12/24
drop
  interfaces: enp0s3
[..]
  ```






