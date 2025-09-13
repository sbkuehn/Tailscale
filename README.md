# Site-to-Site Networking with Tailscale on Azure

This repo contains scripts and documentation to replace an **Azure Site-to-Site VPN** with **Tailscale subnet routers**.  
It demonstrates how to extend an on-premises network into Azure across multiple regions without expensive VPN gateways.

---

## Repo Structure

```
.
├── deploy-ts-router.sh        # Script to deploy a lightweight Ubuntu VM in Azure as a router
├── configure-tailscale-wus.sh # Script to install and configure Tailscale on the router VM
├── create-udr.sh              # Script to create and associate an Azure Route Table (UDR)
└── README.md                  # This file (comprehensive guide)
```

---

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed and logged in:
  ```bash
  az login
  ```
- An existing Azure VNet and subnet in your chosen region.
- An on-premises environment with a Tailscale-capable device (UDM Pro, Linux router, Raspberry Pi, etc.).
- A reusable Tailscale **auth key** from the [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys).
- A static private IP for your router VM’s NIC in Azure.

---

## Scripts Overview

### 1. Deploy the Router VM
Use `deploy-ts-router.sh` to create a small Ubuntu VM in Azure that will run Tailscale as a subnet router.

```bash
chmod +x deploy-ts-router.sh
RG=myResourceGroup VNET=myVnet SUBNET=mySubnet VM=my-router LOCATION=westus ./deploy-ts-router.sh
```

This creates:
- A NIC in your specified subnet.
- An Ubuntu VM (default size: `Standard_B1ms`) with SSH keys enabled.

---

### 2. Configure Tailscale on the VM
Once the VM is deployed, SSH into it and run `configure-tailscale-wus.sh`:

```bash
chmod +x configure-tailscale-wus.sh
TS_AUTHKEY=tskey-auth-xxxx TS_SUBNET=10.10.0.0/16 TS_HOSTNAME=sbk-wus-router01 ./configure-tailscale-wus.sh
```

This will:
- Install the latest Tailscale client.
- Bring up the router with subnet routing enabled.
- Advertise your Azure VNet CIDR to the tailnet.

Approve the routes in the Tailscale Admin Console.

---

### 3. Create a Route Table (UDR)
Use `create-udr.sh` to direct Azure subnet traffic back through the router VM:

```bash
chmod +x create-udr.sh
RG=myResourceGroup VNET=myVnet SUBNET=mySubnet RT_NAME=rt-to-onprem ROUTE_NAME=to-onprem ADDRESS_PREFIX=192.168.1.0/24 NEXT_HOP_IP=10.10.1.5 ./create-udr.sh
```

This will:
- Create a route table.
- Add a route for the on-prem network to the router VM.
- Associate the UDR with your workload subnet.

---

## Example Architecture

- **On-premises UDM Pro** advertises `192.168.1.0/24`
- **Azure East US Router VM** advertises `10.5.0.0/16`
- **Azure West US Router VM** advertises `10.10.0.0/16`
- Tailscale handles the mesh, eliminating the need for Azure VPN gateways.

---

## Notes and Best Practices

- Start small with `/32` or `/24` routes to test, then expand to `/16` once validated.
- Always use **static NIC private IPs** for router VMs.
- Approve routes in the Tailscale admin console after advertising them.
- Never commit real Tailscale auth keys — use placeholders or environment variables.
- Standard VPN Gateway + Standard Public IP behaves differently from Basic SKUs. This repo assumes modern networking defaults.

---

## References

- [Tailscale Subnet Routers](https://tailscale.com/kb/1019/subnets)  
- [Azure Virtual Networks](https://learn.microsoft.com/azure/virtual-network/virtual-networks-overview)  
- [Azure Route Tables](https://learn.microsoft.com/azure/virtual-network/manage-route-table)

---

## License

MIT License. Use at your own risk. Contributions welcome.

