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

## Description

The purpose of this readme file is to guide you through the process of creating isolated networking environments and securing them using namespaces and Linux tools. 

## Table of Contents

Set up of two containers simulating isolated environments using docker (e.i, Team A and Team B).

Usage of Linux network namespaces to ensure the two containers cannot communicate directly.

Creation of a bridge network that allows selective communication between thr  containers using iptables.

Testing the setup using tools like ping and curl.

A script to automate the creation of the setup above.

## Body
Firstly, begin by using docker to create a bridge network that allows selective communication between containers using iptables and here our two containers are named Team_A and Team_B. To create a bridge network that allows selective communication between the two containers using iptables, follow these steps:

 ### 1. Create a Bridge Network: 
First, create a custom bridge network using Docker. This network will be used to connect containers that need to communicate with each other 

```docker network create --driver bridge mybridgenet```

The docker network create command is used to create a new network in Docker. The --driver option specifies the driver to use for the network (for example: bridge, host, none, overlay) but in this case our driver is the bridge  and the name of the network is provided as an argument which is mybridgenet.

### 2. Launch Containers: 
Launch the containers and connect them to the custom bridge network.

```docker run -d --name Team_A --network=mybridgenet ubuntu```

```docker run -d --name Team_B --network=mybridgenet ubuntu```

The docker run command is used to create and start two new containers, Team_A and Team_B, from the Ubuntu image. Both containers are connected to the mybridgenet network. The docker run command is the base command to create and start a new container. The -d flag runs the container in detached mode, meaning it runs in the background and does not block the 
terminal. The --name option specifies the names of the containers. The --network=mybridgenet option connects the containers to the mybridgenet network. Like I said before, ubuntu is the name of the Docker image to use for the containers.

### 3. Configure iptables Rules: 
Use iptables to allow selective communication between the containers on the bridge network. To allow communication between the containers, you can add the following iptables rules:

```iptables -I FORWARD -s 172.19.0.2/24 -d 172.19.0.3/24 -j ACCEPT```

```iptables -I FORWARD -d 172.19.0.2/24 -s 172.19.0.3/24 -j ACCEPT```

The iptable command is used to configure the firewall rules on a Linux system to allow traffic between two specific IP addresses. The -I option inserts a new rule at the beginning of the specified chain (in this case, FORWARD). The FORWARD chain handles packets that are being forwarded through the system (i.e., not destined for or originating from the system itself). The -s 172.19.0.2/24 option specifies the source IP address of the packets to match. The -d 172.19.0.3/24 option specifies the destination IP address of the packets to match. The -j ACCEPT option specifies the target of the rule which determines what action to take when a packet matches the rule. In this case, the target is ACCEPT which means that the packet should be allowed to pass through the firewall.

Now, in this case we want selective connection between the containers and this means that we have to ensure that only one container can ping the other and here only Team_A should able to ping Team_B and not vice versa so we will drop the IP address of Team_B and the source will become the IP address of Team_B and the destination will become the IP address of Team_A. It can be executed using this command:

```iptables -I FORWARD -s 172.19.0.3/24 -d 172.19.0.2/24 -j DROP```

#### NB: 
Use this command to get the IP addresses of the containers:

```docker inspect <container name> | grep IPAdress```

### 4. Ensure iptables Rules Persist: 
To ensure that the iptables rules persist over reboots, a directory was created in the /etc directory called iptables and a file named rules.v4 was also created in the iptables directory where the rules were saved to be executable over reboots. But if the the directory and the file already exists just run the command:

```sudo iptables-save > /etc/iptables/rules.v4```

The iptables-save command is used to save the current iptables rules to the file rules.v4. This command > /etc/iptables/rules.v4 redirects the output of the iptables-save command to a file named /etc/iptables/rules.v4. When you run the command, the following happens:

The iptables-save command reads the current iptables rules from the kernel.

The rules are then written to the file /etc/iptables/rules.v4 in a format that can be read by the iptables-restore command. When you run the iptables-restore command, it reads the iptables rules from the specified file and applies them to the kernel. The rules are applied in the order they appear in the file, and any existing rules are replaced by the new ones.

The file /etc/iptables/rules.v4 now contains a copy of the current iptables rules.

### 5. Test setup using ping:
Now, login to Team_A and try pinging Team_B using the command:
 
```docker exec -it Team_A bash```

```ping Team_B```

Then do same for Team_B

At this point it won't work for Team_B because it's a selective communication so it's one-sided. Also you may encounter an error saying "ping command not found" in the cause of pinging Team_B but bother not! Simply install ping using the command:

```sudo apt install iputils-ping```

But before doing this update the the package index using the command:

```sudo apt update```


 
