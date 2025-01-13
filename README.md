# Network-Isolation-and-Security-with-Namespaces

docker network create --driver bridge mybridgenet

docker run -d --name Team_A --network=mybridgenet ubuntu

docker run -d --name Team_B --network=mybridgenet ubuntu

iptables -I FORWARD -s 172.19.0.2/24 -d 172.19.0.3/24 -j ACCEPT

iptables -I FORWARD -d 172.19.0.2/24 -s 172.19.0.3/24 -j ACCEPT

iptables -I FORWARD -s 172.19.0.3/24 -d 172.19.0.2/24 -j DROP

sudo iptables-save > /etc/iptables/rules.v4

docker exec -it Team_B bash

docker exec -it Team_A bash

ping Team_A

ping Team_B
