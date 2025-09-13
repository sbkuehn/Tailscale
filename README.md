# Configure Tailscale Router in Azure

This script installs and configures **Tailscale** on an Ubuntu VM in your preferred Azure region.  
The VM acts as a **subnet router**, advertising your Azure VNet into your Tailscale tailnet.

---

## Prerequisites

- Azure VM deployed (Ubuntu 22.04 recommended)
- SSH access to the VM
- A reusable Tailscale auth key (from the [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys))
- `curl` installed on the VM

---

## Usage

1. Copy the script to your VM or run directly from GitHub:

   ```bash
   curl -O https://raw.githubusercontent.com/<your-repo>/configure-tailscale.sh
   chmod +x configure-tailscale.sh
   ./configure-tailscale.sh
