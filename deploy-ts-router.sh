#!/bin/bash
# ------------------------------------------------------
# Deploy a lightweight Ubuntu VM to act as a Tailscale router in Azure
# Region: configurable (defaults to West US)
# Author: Shannon Eldridge-Kuehn
# ------------------------------------------------------

# Variables (edit these or override with environment variables when running)
RG=${RG:-"myResourceGroup"}        # Azure Resource Group
VNET=${VNET:-"myVnet"}             # Azure VNet name
SUBNET=${SUBNET:-"mySubnet"}       # Subnet name
NIC=${NIC:-"ts-router-nic"}        # NIC name
VM=${VM:-"ts-router"}              # VM name
LOCATION=${LOCATION:-"westus"}     # Azure region

# VM settings
SIZE=${SIZE:-"Standard_B1ms"}      # VM size
IMAGE=${IMAGE:-"Ubuntu2204"}       # OS image
ADMIN_USER=${ADMIN_USER:-"azureuser"}

echo "------------------------------------------------------"
echo "Deploying Tailscale Router VM into Azure"
echo "Resource Group: $RG"
echo "VNet: $VNET, Subnet: $SUBNET"
echo "VM: $VM, Location: $LOCATION"
echo "------------------------------------------------------"

# Create NIC
echo "Creating NIC: $NIC..."
az network nic create \
  --resource-group "$RG" \
  --name "$NIC" \
  --vnet-name "$VNET" \
  --subnet "$SUBNET"

# Create VM
echo "Creating VM: $VM..."
az vm create \
  --resource-group "$RG" \
  --name "$VM" \
  --location "$LOCATION" \
  --size "$SIZE" \
  --nics "$NIC" \
  --image "$IMAGE" \
  --admin-username "$ADMIN_USER" \
  --generate-ssh-keys

echo "------------------------------------------------------"
echo "Deployment complete!"
echo "Next steps:"
echo "1. SSH into the VM:"
echo "   ssh $ADMIN_USER@<VM-Private-IP>"
echo "2. Install Tailscale:"
echo "   curl -fsSL https://tailscale.com/install.sh | sh"
echo "   sudo tailscale up --authkey tskey-auth-REPLACE-ME --advertise-routes=<YOUR-SUBNET> --accept-routes"
echo "3. Approve routes in the Tailscale admin console."
echo "------------------------------------------------------"
