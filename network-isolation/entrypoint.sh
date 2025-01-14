#!/bin/bash

# Apply iptables rules
iptables -I FORWARD -s 172.19.0.2/24 -d 172.19.0.3/24 -j ACCEPT
iptables -I FORWARD -d 172.19.0.2/24 -s 172.19.0.3/24 -j ACCEPT
iptables -I FORWARD -s 172.19.0.3/24 -d 172.19.0.2/24 -j DROP

# Save iptables rules
iptables-save > /etc/iptables/rules.v4

# Keep the container running for debugging
tail -f /dev/null

