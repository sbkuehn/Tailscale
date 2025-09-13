#!/bin/bash
# ------------------------------------------------------
# Install and configure Tailscale as a subnet router on Azure VM (West US)
# Author: Shannon Eldridge-Kuehn
# ------------------------------------------------------

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Bring up Tailscale with subnet routing enabled
sudo tailscale up \
  --authkey tskey-auth-YOUR-KEY-HERE \
  --advertise-routes=10.10.0.0/16 \
  --accept-routes \
  --hostname sbk-wus-router01
