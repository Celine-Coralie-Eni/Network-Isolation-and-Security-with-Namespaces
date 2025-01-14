### Docker Networking with Custom iptables Rules ###
### Overview ###

This project demonstrates how to configure and manage custom networking between Docker containers using docker-compose, custom Docker images, and iptables rules. It creates two containers, Team_A and Team_B
, connected to a custom bridge network.
The iptables rules enforce specific communication policies between the containers.
** Features **

**install docker in your machine if not found ***
```sudo apt install docker.io```
  **Custom Bridge Network:** A private Docker network (mybridgenet) is used to isolate the containers.
  **Static IP Allocation:** Each container is assigned a fixed IP address within the custom network.
  ** Custom iptables Rules:**
        Allow traffic from Team_A to Team_B and vice versa.
        Block traffic originating from Team_B to Team_A.
    Dynamic Rule Configuration: iptables rules are dynamically applied using an entrypoint script.

**Prerequisites**
Ensure the following software is installed and properly configured:

**Docker**: Version 20.10 or later.
**Docker Compose**: Version 1.29 or later.

**Project Structure**

.
Dockerfile           # Builds the custom Docker image with necessary tools
entrypoint.sh        # Configures iptables rules during container startup
docker-compose.yml   # Defines the services and custom network
README.md            # Project documentation

**Setup and Usage **
**1.** Build and Start Containers

Run the following command to build the Docker image and start the containers:

```docker-compose up -d ```

**2.** Verify Container Status

Check the status of the containers:

```docker ps```

You should see Team_A and Team_B running and connected to the custom network.

**3.** Access Containers
To access the shell of the containers, use the following commands:

```docker exec -it Team_A bash```
```docker exec -it Team_B bash```

**4.** Test Connectivity

From within the Team_A container:

```ping Team_B ```

From within the Team_B container:

```ping Team_A```

You should observe:

    Team_A can ping Team_B.
    Team_B cannot ping Team_A.
**if ping command not found **
``` apt-get iputils-ping ```
### Configuration Details ###
#### Custom Network ####

The docker-compose.yml defines a bridge network (mybridgenet) with the following properties:

    Subnet: 172.19.0.0/24
    Static IPs:
        Team_A: 172.19.0.2
        Team_B: 172.19.0.3

#### iptables Rules ####

The entrypoint.sh script dynamically configures the following rules:

    For Team_A:
        Allow traffic from 172.19.0.2 to 172.19.0.3.
        Allow traffic from 172.19.0.3 to 172.19.0.2.
    For Team_B:
        Block traffic from 172.19.0.3 to 172.19.0.2.

#### Persisting iptables Rules ####

**The rules are saved to /etc/iptables/rules.v4 to ensure persistence.**
**Key Commands**

   **Start Services:** docker-compose up -d
    **Stop Services:** docker-compose down
    **Rebuild Containers:** docker-compose up --build -d
    **Access Logs:** docker-compose logs -f
    **Access Container Shell:** docker exec -it <container_name> bash

**Customization**

  **Network Configuration:** Modify the networks section in docker-compose.yml to change the subnet or network name.

 **iptables Rules:** Update the entrypoint.sh script to define custom traffic rules as per your requirements.

 **Docker Images:** Extend the Dockerfile to include additional tools or dependencies.
