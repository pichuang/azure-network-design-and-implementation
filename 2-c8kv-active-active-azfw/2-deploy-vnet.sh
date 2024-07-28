#!/bin/bash

source ./vars.sh

echo "Creating Hub Virtual Network..."
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $HUB_VNET_NAME \
    --address-prefixes $HUB_VNET_PREFIX

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $HUB_VNET_NAME \
    --name $HUB_SUBNET_GATEWAY_NAME \
    --address-prefix $HUB_SUBNET_GATEWAY_PREFIX

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $HUB_VNET_NAME \
    --name $HUB_SUBNET_ARS_NAME \
    --address-prefix $HUB_SUBNET_ARS_PREFIX

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $HUB_VNET_NAME \
    --name $HUB_SUBNET_C8KV_TRANSPORT_NAME \
    --address-prefix $HUB_SUBNET_C8KV_TRANSPORT_PREFIX \
    --network-security-group $NSG_TRANSPORT_NAME

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $HUB_VNET_NAME \
    --name $HUB_SUBNET_C8KV_SERVICE_NAME \
    --address-prefix $HUB_SUBNET_C8KV_SERVICE_PREFIX \
    --network-security-group $NSG_SERVICE_NAME

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $HUB_VNET_NAME \
    --name $HUB_SUBNET_VM_NAME \
    --address-prefix $HUB_SUBNET_VM_PREFIX \
    --network-security-group $NSG_VM_NAME

echo "Creating Serverfarm Virtual Network..."
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $SPOKE_VNET_NAME \
    --address-prefixes $SPOKE_VNET_PREFIX

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $SPOKE_VNET_NAME \
    --name $SPOKE_SUBNET_AZFW_NAME \
    --address-prefix $SPOKE_SUBNET_AZFW_PREFIX

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $SPOKE_VNET_NAME \
    --name $SPOKE_SUBNET_SERVERFARM_NAME \
    --address-prefix $SPOKE_SUBNET_SERVERFARM_PREFIX \
    --network-security-group $NSG_VM_NAME

#
# VNet Peering
#
az network vnet peering create \
    --resource-group $RESOURCE_GROUP \
    --name $HUB_VNET_NAME-to-$SPOKE_VNET_NAME \
    --vnet-name $HUB_VNET_NAME \
    --remote-vnet $SPOKE_VNET_NAME \
    --allow-vnet-access \
    --allow-forwarded-traffic \
    --allow-gateway-transit \

az network vnet peering create \
    --resource-group $RESOURCE_GROUP \
    --name $SPOKE_VNET_NAME-to-$HUB_VNET_NAME \
    --vnet-name $SPOKE_VNET_NAME \
    --remote-vnet $HUB_VNET_NAME \
    --allow-vnet-access \
    --allow-forwarded-traffic \
    # --use-remote-gateways