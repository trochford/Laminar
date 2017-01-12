#!/bin/bash

# IP will hold the IP address of the Registry
IP=$1

# Create an environment variable myReg to hold the Registry address
source ~/.profile
if [ -z "$myReg" ] || [ "$myReg" != "$IP" ]; then 
    echo "export myReg=${IP}" >> ~/.profile
fi
