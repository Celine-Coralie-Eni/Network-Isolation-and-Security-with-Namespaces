
FROM ubuntu:latest

# Install iptables and other necessary tools
RUN apt-get update && apt-get install iputils-ping && apt-get install -y iptables iproute2 && rm -rf /var/lib/apt/lists/*

# Copy the custom startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN /entrypoint.sh
# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]


