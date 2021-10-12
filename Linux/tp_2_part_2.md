# TP2 pt. 2 : Maintien en condition opérationnelle

### 🌞 Manipulation du service Netdata

[yaniss@web ~]$ systemctl is-enabled netdata
enabled

[yaniss@web ~]$ ss -lta
LISTEN      0       128                 0.0.0.0:19999              0.0.0.0:*

[yaniss@web ~]$ sudo firewall-cmd --add-port=19999/tcp --permanent


### 🌞 Setup Alerting

J'execute la commande suivante 

[yaniss@web ~]$sudo /opt/netdata/etc/netdata/edit-config health_alarm_notify.conf

Et je modifie la lgine suivante en collant l'url du webhook copié depuis Discord.

# Create a webhook by following the official documentation -
# https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/897411024083382304/O8LC1hui2huWEGJez8BHBoIoODNicGZLPOsyGv0s8KkGEgOt0wPtj2JGbhQ1PeAGuq_o"


Puis dans le bash netdata j'execute la commande suivante.

bash-4.4$ /opt/netdata/usr/libexec/netdata/plugins.d/alarm-notify.sh test

Et je remarque la reception de messages d'alertes dans le serveur Discord.

Je creer le fichier suivant netdata/health.d.

[yaniss@web health.d]$ cat ram-usage.conf
 alarm: ram_usage
    on: system.ram
lookup: average -1m percentage of used
 units: %
 every: 1m
  warn: $this > 50
  crit: $this > 50
  info: The percentage of RAM being used by the system.
  
 Je restart le service et avec la commande stress je diminue l'espace libre sur ma RAM.
 
 [yaniss@web health.d]$ stress -m 1 --vm-bytes 3000M --vm-keep (Pour rappel ma VM dispose de 3.5 GO d'espace)
 
 Apres seulement 1 minute, j'ai bien recu des alertes sur Discord avec comme titre "ram in use = 94.8%"
