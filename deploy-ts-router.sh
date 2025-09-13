#!/bin/bash
# ------------------------------------------------------
# Deploy a lightweight Ubuntu VM to act as a Tailscale router in Azure (West US)
# Author: Shannon Kuehn
# ------------------------------------------------------

# Variables
RG="sbkWusHub"
VNET="sbkWusHubVnet"
SUBNET="sbkWusHubSub1"
NIC="sbk-wus-ts-router01-nic"
VM="sbk-wus-ts-router01"
LOCATION="westus"

# Create NIC
echo "Creating NIC: $NIC in Resource Group: $RG..."
az network nic create \
  --resource-group $RG \
  --name $NIC \
  --vnet-name $VNET \
  --subnet $SUBNET

# Create VM
echo "Creating VM: $VM in $LOCATION..."
az vm create \
  --resource-group $RG \
  --name $VM \
  --location $LOCATION \
  --size Standard_B1ms \
  --nics $NIC \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys

echo "Deployment complete!"
echo "Next steps: SSH into the VM and install Tailscale."
