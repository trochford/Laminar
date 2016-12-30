#!/bin/bash

# IP will hold the IP address of the Registry
IP=$1

# Create an environment variable REG_IP to hold the Registry address
source ~/.profile
if [ -z "$REG_IP" ] || [ "$REG_IP" != "$IP" ]; then 
    echo "export REG_IP=${IP}" >> ~/.profile
fi
