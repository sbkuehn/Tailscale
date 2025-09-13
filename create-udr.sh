#!/bin/bash
# ------------------------------------------------------
# Create an Azure Route Table (UDR) and associate it with a subnet
# Author: Shannon Eldridge-Kuehn
# ------------------------------------------------------

# Variables (set these before running or override inline)
RG=${RG:-"myResourceGroup"}                # Resource Group
RT_NAME=${RT_NAME:-"myRouteTable"}         # Route Table name
ROUTE_NAME=${ROUTE_NAME:-"to-onprem"}      # Route name
ADDRESS_PREFIX=${ADDRESS_PREFIX:-"REPLACEME"} # Destination address prefix
NEXT_HOP_IP=${NEXT_HOP_IP:-"REPLACEME"}    # Next hop IP (router VM private IP)
VNET=${VNET:-"myVnet"}                     # VNet name
SUBNET=${SUBNET:-"mySubnet"}               # Subnet name

echo "------------------------------------------------------"
echo "Creating Route Table: $RT_NAME in Resource Group: $RG"
echo "------------------------------------------------------"

# Create route table
az network route-table create \
  --resource-group "$RG" \
  --name "$RT_NAME"

# Add route
echo "Adding route: $ROUTE_NAME..."
az network route-table route create \
  --resource-group "$RG" \
  --route-table-name "$RT_NAME" \
  --name "$ROUTE_NAME" \
  --address-prefix "$ADDRESS_PREFIX" \
  --next-hop-type VirtualAppliance \
  --next-hop-ip-address "$NEXT_HOP_IP"

# Associate with subnet
echo "Associating Route Table with subnet: $SUBNET in VNet: $VNET..."
az network vnet subnet update \
  --resource-group "$RG" \
  --vnet-name "$VNET" \
  --name "$SUBNET" \
  --route-table "$RT_NAME"

echo "------------------------------------------------------"
echo "Route Table deployment complete!"
echo "Destination $ADDRESS_PREFIX will now route to $NEXT_HOP_IP."
echo "------------------------------------------------------"
