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

# Exemples de regles output
#####################################
#accedir a qualsevol port destí
iptables -A OUTPUT -j ACCEPT
#provem  al local: telnet i04 13
#accedir al port 13 de qualsevol destí
iptables -A OUTPUT -p tcp --dport 13 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 13 -d 0.0.0.0/0 -j ACCEPT
#accedir a qualsevol port 2013 excepte el del i04
iptables -A OUTPUT -p tcp --dport 2013 -d 192.168.2.34 -j DROP
iptables -A OUTPUT -p tcp --dport 2013 -j ACCEPT
#denegar l'acces a qualsevol port 3013 excepte el i04
iptables -A OUTPUT -p tcp --dport 3013 -d 192.168.2.34 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3013 -j DROP
#obert acces a tothom, tancat classe, obert al i05, port 4013
iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.2.34 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.2.0/24 -j DROP
iptables -A OUTPUT -p tcp --dport 4013 -j ACCEPT
#no es pot accedir a cap PORT 80,13,7
iptables -A OUTPUT -p tcp --dport 80 -j REJECT
iptables -A OUTPUT -p tcp --dport 13 -j REJECT
iptables -A OUTPUT -p tcp --dport 7 -j REJECT
#no es pot accedir al host i04 ni al i05
iptables -A OUTPUT -d 192.168.2.34 -j REJECT
iptables -A OUTPUT -d 192.168.2.35 -j REJECT
#no podem accedir a la xarxa hisx2 (2) i hisx1 (1)
iptable -A OUTPUT -d 192.168.2.0/24 -j REJECT
iptable -A OUTPUT -d 192.168.1.0/24 -j REJECT
#dins la xarxa hisx2 no s'hi pot accedir excepte amb ssh
iptable -A OUTPUT -p tcp --dport 22 -d 192.168.2.0/24  -j ACCEPT
iptable -A OUTPUT -d 192.168.2.0/24 -j REJECT
