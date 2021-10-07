# TP2 pt. 1 : Gestion de service

## I. Un premier serveur web

### 1. Installation

#### 🌞 Installer le serveur Apache
‘‘‘
[yaniss@web ~]$ sudo dnf install -y httpd

...
‘‘‘

#### 🌞 Démarrer le service Apache
‘‘‘

[yaniss@web ~]$ systemctl enable httpd.service
‘‘‘
‘‘‘

[yaniss@web ~]$ systemctl start httpd.service
‘‘‘
‘‘‘


[yaniss@web ~]$ systemctl status httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor prese>
   Active: active (running) since Wed 2021-09-29 17:50:35 CEST; 2min 24s ago
‘‘‘
‘‘‘
   

[yaniss@web ~]$ sudo firewall-cmd --add-port=80/tcp
‘‘‘
‘‘‘


[yaniss@web ~]$ sudo ss -alnpt
LISTEN    0         128                      *:80                      *:*        users:(("httpd",pid=863,fd=4),("httpd",pid=862,fd=4),("httpd",pid=861,fd=4),("httpd",pid=836,fd=4))
‘‘‘

Pour tester rapidement que mon mon serveur tourne, avec la commande curl localhost:80 j'obtiens bien le contenu de ma page html. Depuis ma propre machine je rentre l'ip de ma machine suivi du port 80 et j'obtiens aussi le contenu de ma page html.


### 2. Avancer vers la maîtrise du service

#### 🌞 Le service Apache...

Voici la commande qui permet d'activer le démarrage automatique d'Apache quand la machine s'allume
[yaniss@web ~]$ systemctl enable httpd.service

Avec la commande suivante je prouve que le service est parametrer pour demarrer au demarage.
‘‘‘

[yaniss@web ~]$ systemctl is-enabled httpd.service
enabled 
‘‘‘

J'affiche le contenu du fichier httpd.service.
‘‘‘

[yaniss@web ~]$ cat /usr/lib/systemd/system/httpd.service
#	[Service]
#	Environment=OPTIONS=-DMY_DEFINE

[Unit]
Description=The Apache HTTP Server
Wants=httpd-init.service
After=network.target remote-fs.target nss-lookup.target httpd-init.service
Documentation=man:httpd.service(8)

[Service]
Type=notify
Environment=LANG=C

ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
# Send SIGWINCH for graceful stop
KillSignal=SIGWINCH
KillMode=mixed
PrivateTmp=true

[Install]
WantedBy=multi-user.target
‘‘‘

🌞 Déterminer sous quel utilisateur tourne le processus Apache
‘‘‘

[yaniss@web ~]$ cat /etc/httpd/conf/httpd.conf 
User apache
‘‘‘

Avec la commade ps -ef je visualise le process apache et l'user avec lequel le process tourne.
‘‘‘

[yaniss@web ~]$ ps -ef
root        1920       1  0 17:17 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1921    1920  0 17:17 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1922    1920  0 17:17 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1923    1920  0 17:17 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1924    1920  0 17:17 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
‘‘‘

Je vérifie ensuite que tout le contenu est accesible à l'utilisateur mentionné dans le fichier de conf
‘‘‘

[yaniss@web ~]$ ls -al /var/www/
drwxr-xr-x.  4 root root   33 29 sept. 12:32 .
drwxr-xr-x. 22 root root 4096 29 sept. 12:32 ..
drwxr-xr-x.  2 root root    6 11 juin  17:35 cgi-bin
drwxr-xr-x.  2 root root    6 11 juin  17:35 html
‘‘‘

On remarque que tout le dossier est executable et lisile pour le groupe apache.


### 🌞 Changer l'utilisateur utilisé par Apache

J'ajoute un nouvel user 
‘‘‘

[yaniss@web ~]$ sudo useradd -d /usr/share/httpd -s /sbin/nologin  myUser

‘‘‘

Dans le fichier /etc/httpd/conf/httpd.conf je modifie la ligne ou l'user est apache par myUser.
Puis de nouveau avec la commande ps -ef.
‘‘‘

[yaniss@web ~]$ ps -ef
newUser     1820    1819  0 18:05 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
newUser     1821    1819  0 18:05 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
newUser     1822    1819  0 18:05 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
newUser     1823    1819  0 18:05 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
‘‘‘

🌞 Faites en sorte que Apache tourne sur un autre port

Je modifie la ligne spécifiant sur quel port écoute le serveur en rajoutant 8080 a la place de 80, tout en n'oubliant pas d'ajouter le port 8080 en tcp dans la conf du service firewall.

En relancant le service, on remarque avec la commande SS(pas Schutzstaffel bien sur) que le port 8080 fait tourner bien un service.
‘‘‘

[yaniss@web ~]$ sudo ss -alnpt
[...]
LISTEN    0         128                      *:8888                    *:*        users:(("httpd",pid=2155,fd=4),("httpd",pid=2154,fd=4),("httpd",pid=2153,fd=4),("httpd",pid=2150,fd=4))
[...]
‘‘‘

De nouveau, pour tester rapidement que mon mon serveur tourne, avec la commande curl localhost:8080 j'obtiens bien le contenu de ma page html. Depuis ma propre machine je rentre l'ip de ma machine suivi du port 8080 et j'obtiens aussi le contenu de ma page html.




