#!/bin/bash

# Global Variables
SUBSCRIPTION_ID="subscription-any-projects"
LOCATION="southeastasia"
POSTFIX="sea"
RESOURCE_GROUP="rg-c8kv-$POSTFIX"

# ===============
# Virtual Network
# ===============
# Hub VNet
# - ExpressRoute Gateway
# - VPN Gateway
# - Azure Route Server
# - c8kv
#
HUB_VNET_NAME="vnet-hub-$POSTFIX"
HUB_VNET_PREFIX="10.0.0.0/24"
# ExpressRourte Gateway + VPN Gateway
HUB_SUBNET_GATEWAY_NAME="GatewaySubnet"
HUB_SUBNET_GATEWAY_PREFIX="10.0.0.0/27"
# Azure Route Server
HUB_SUBNET_ARS_NAME="RouteServerSubnet"
HUB_SUBNET_ARS_PREFIX="10.0.0.32/27"
# c8kv - WAN side
HUB_SUBNET_C8KV_TRANSPORT_NAME="subnet-c8kv-transport"
HUB_SUBNET_C8KV_TRANSPORT_PREFIX="10.0.0.64/27"
# c8kv - LAN side
HUB_SUBNET_C8KV_SERVICE_NAME="subnet-c8kv-service"
HUB_SUBNET_C8KV_SERVICE_PREFIX="10.0.0.96/27"
# Jumpbox VM
HUB_SUBNET_VM_NAME="subnet-hub-vm"
HUB_SUBNET_VM_PREFIX="10.0.0.192/27"

# Spoke VNet
# - serverfarm
SPOKE_VNET_NAME="vnet-serverfarm-$POSTFIX"
SPOKE_VNET_PREFIX="10.99.99.0/24"
# Spoke VM
SPOKE_SUBNET_SERVERFARM_NAME="subnet-serverfarm-$POSTFIX"
SPOKE_SUBNET_SERVERFARM_PREFIX="10.99.99.64/27"

# ===============
# Network Security Group
# ===============
NSG_TRANSPORT_NAME="nsg-c8kv-transport-$POSTFIX"
NSG_SERVICE_NAME="nsg-c8kv-service-$POSTFIX"
NSG_VM_NAME="nsg-vm-$POSTFIX"

#
# Internal Load Balancer
#
ILB_NAME="ilb-c8kv-$POSTFIX"
ILB_FRONTEND_NAME="ilb-c8kv-frontend"
ILB_FRONTEND_PRIVATE_IP="10.0.0.102"
ILB_BACKEND_POOL_NAME="ilb-c8kv-backend"


#
# VM Global Variables
#
ADMIN_USERNAME="cisco"
ADMIN_PASSWORD="n7shXuaSyL4zBA5rvmcFZb"
# https://learn.microsoft.com/en-us/azure/virtual-machines/dv2-dsv2-series#dv2-series
VM_SIZE="Standard_D2_v2" # Standard_D4_v2

# az vm image list-offers --location southeastasia --publisher cisco --output table
# az vm image list-skus --location southeastasia --publisher cisco --offer cisco-c8000v-byol --output table
# az vm image list --location southeastasia --publisher cisco --offer cisco-c8000v-byol --sku 17_14_01a-byol --all --output table
# az vm image terms accept --urn cisco:cisco-c8000v-byol:17_14_01a-byol:17.14.0120240501
SKU_IMAGE="cisco:cisco-c8000v-byol:17_14_01a-byol:17.14.0120240501"

# ===============
# C8KV-1
# ===============
C8KV1_NAME="c8kv-1"
C8KV1_TRANSPORT_PRIVATE_IP="10.0.0.68"
C8KV1_SERVICE_PRIVATE_IP="10.0.0.100"

# ===============
# C8KV-2
# ===============
C8KV2_NAME="c8kv-2"
C8KV2_TRANSPORT_PRIVATE_IP="10.0.0.69"
C8KV2_SERVICE_PRIVATE_IP="10.0.0.101"

# ===============
# Bastion VM
# ===============
BASTION_NAME="bastion"
BASTION_PRIVATE_IP="10.0.0.196"

# ===============
# ServerFarm VM
# ===============
SERVERFARM_NAME="vm-serverfarm"
SERVERFARM_PRIVATE_IP="10.99.99.68"

#
# Route Table
#
RT_HUB_NAME="rt-serverfarm-$POSTFIX"