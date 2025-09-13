#!/bin/bash
# ------------------------------------------------------
# Install and configure Tailscale as a subnet router on Azure VM (West US)
# Author: Shannon Eldridge-Kuehn
# ------------------------------------------------------

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Variables (edit these)
TS_AUTHKEY=${TS_AUTHKEY:-"tskey-auth-REPLACE-ME"}
TS_SUBNET=${TS_SUBNET:-"REPLACEME"}
TS_HOSTNAME=${TS_HOSTNAME:-"REPLACEME"}

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Bring up Tailscale
sudo tailscale up \
  --authkey $TS_AUTHKEY \
  --advertise-routes=$TS_SUBNET \
  --accept-routes \
  --hostname $TS_HOSTNAME
