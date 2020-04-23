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
iptables -A INPUT -s 192.168.2 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.18 -j ACCEPT

# Xapat ports 80... ############################
# port 80 obert a tothom
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# port 2080 tancat a tothom: reject
iptables -A INPUT -p tcp --dport 2080 -j REJECT
# port 3080 tancat a tothom: drop
iptables -A INPUT -p tcp --dport 3080 -j DROP
# port 4080 tancat a tothom exceprte i26
iptables -A INPUT -p tcp --dport 4080 -s 192.168.2.56  -j ACCEPT
iptables -A INPUT -p tcp --dport 4080 -j DROP
# port 5080 obert a tothom tancat a i26
iptables -A INPUT -p tcp --dport 5080 -s 192.168.2.56 -j REJECT
iptables -A INPUT -p tcp --dport 5080 -j ACCEPT
# port 6080 tancat a tohom, obert a hisx2 tancat a i26
iptables -A INPUT -p tcp --dport 6080 -s 192.168.2.56 -j REJECT
iptables -A INPUT -p tcp --dport 6080 -s 192.168.2.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 6080 -j DROP
##############################################

# port 7080 obert a tothom,tancat hisx2, obert a i04
iptables -A INPUT -p tcp --dport 7080 -s 192.168.2.34 -j ACCEPT
iptables -A INPUT -p tcp --dport 7080 -s 192.168.2.0/24 -j DROP
iptables -A INPUT -p tcp --dport 7080 -j ACCEPT

##############################################

#tancar acces ports del 3000 al 8000
#iptables -A INPUT -p tcp --dport 3000:8000 -j REJECT
#barreres finals de tancar (quedar tancat!)
#iptables -A INPUT -p tcp --dport 1:1024 -j DROP 
##############################################
