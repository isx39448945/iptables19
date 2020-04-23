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
iptables -A INPUT -s 192.168.2.40 -j ACCEPT
iptables -A OUTPUT -d 192.168.2.40 -j ACCEPT


#FER NAT PER LES XARXES INTERNES:
# 172.21.0.0/24
# 172.22.0.0/24
iptables -t nat -A POSTROUTING -s 172.21.0.0/24 -o enp5s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.23.0.0/24 -o enp5s0 -j MASQUERADE

#Exemples de regles de FORWARD
# #####################################
#Xarxa A no pot accedir a xarxa B
iptables -A FORWARD -s  172.21.0.0/16 -d 172.23.0.0/16 -j REJECT
##!! ELS DE LA A NO PODRAN COMUNICAR-SE AMB ELS DE LA B, PERO
# ELS DE LA B SI PODRÀN COMUNICAR-SE PERÒ NO OBTENDRAN RESPOSTA.
#FEM PING : 172.23.0.2 I NO FUNCIONA
#######################################
#CAP DE LA XARXA A NO POT ACCEDIR AL HOST2 DE LA XARXA B 
iptables -A FORWARD -i br-d4264adc095c -d 172.23.0.3 -j REJECT
# -i es interface i agafem el br del 21
#######################################
#EL hostA1 li prohibim anar al hostB2
iptables -A FORWARD -s 172.21.0.2 -d 172.23.0.3 -j REJECT
#######################################
#XARXA A no es pot connectar al port 13
iptables -A FORWARD -p tcp  -s 172.21.0.0/24 --dport 13 -j REJECT
# fem telnet 172.23.0.2 13 / telnet 172.21.0.3 i no deixa
#######################################
#XARXA A no es pot connectar al port 2013 de la xarxa B 
iptables -A FORWARD -p tcp  -s 172.21.0.0/24 -d 172.23.0.0/24 --dport 2013 -j REJECT
# fem telnet 172.23.0.2 2013 i no deixa
######################################
#Permetre navegar( port 80) els de la xarxa A per internet però res més a l'exterior(interfície pública d'internet) (la interfície per on surt internet es enp5s0)
iptables -A FORWARD -p tcp -s 172.21.0.0/24 --sport 80 -i enp5s0 -mstate --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -p tcp -s 172.21.0.0/24 --dport 80  -o enp5s0 -j ACCEPT 
iptables -A FORWARD -s 172.21.0.0/24 -o enp5s0 -j REJECT
iptables -A FORWARD -d 172.21.0.0/24 -i enp5s0 -j REJECT
######################################
#XARXA A pot accedir al port 2013 de totes les xarxes d'internet excepte de la xarxa hisx2
iptables -A FORWARD -p tcp -s 172.21.0.0/24 -d 192.168.2.0/24 --dport 2013 -j REJECT 
iptables -A FORWARD -s 172.21.0.0/24 -p tcp --dport 2013 -o enp5s0 -j ACCEPT
#####################################
#evitar que es falsifiqui la ip de origen: SPOOFING
iptables -A FORWARD ! -s 172.21.0.0/24 -i br-d4264adc095c -j DROP
# si l'adreça origen no es un paquet amb la ip 21 (falsifica la ip origen) fem reject
# qualsevol paquet que arribi el qual la seva ip origen no sigui ip 172.21... REJECT
