#! /bin/bash
# Adrian Narvaez

#echo 1 > /proc/sys/ipv4/ip_forward

# Regles flush
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Polítiques per defecte: 
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# obrir el localhost
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# obrir la nostra ip
iptables -A INPUT -s 192.168.0.18 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.18 -j ACCEPT

#REGLES AMB TRÀFIC RELATED, ESTABLISHED
##########################################
#permetre navegar per internet (MAL FETA)

#A) SORTIDA
#iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
#B) RESPOSTA ENTRADA (tenim port dinamic)
#iptables -A INPUT -p tcp --sport 80 -j ACCEPT

##########################################
#permetre navegar per internet (BEN FETA)
#A) SORTIDA
#iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
#B) RESPOSTA ENTRADA (tenim port dinamic)
#iptables -A INPUT -p tcp --sport 80 -m tcp -m state --state RELATED,ESTABLISHED -j ACCEPT #HA DE SER UNA CONNEXIO QUE JA L'HAGEM INICIAT.

#Oferir el servei web,permetre només respostes
#a peticions establertes

#iptables -A OUTPUT -p tcp --sport 80 -m tcp -m state --state RELATED,ESTABLISHED -j ACCEPT

#iptables -A INPUT -p tcp --dport 80 -j ACCEPT #iniciar sessions en un port

#oferir el servei web a tothom menys al i04

iptables -A INPUT -p tcp -s 192.168.2.34 --dport 80 -j REJECT
iptables -A OUTPUT -p tcp --sport 80 -m tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 80 -j ACCEPT
