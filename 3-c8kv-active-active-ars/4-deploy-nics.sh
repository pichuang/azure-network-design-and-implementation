#!/bin/bash

source ./vars.sh

#
# C8KV-1
#
echo "Creating Public IP for c8kv-1..."
az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name "pip-$C8KV1_NAME-$POSTFIX" \
    --sku "Standard" \
    --location $LOCATION \
    --allocation-method "Static" \
    --tier "Regional" \
    # --zone 1 2 3

echo "Creating Transport NIC for c8kv-1..."
az network nic create \
    --resource-group $RESOURCE_GROUP \
    --name "nic-$C8KV1_NAME-transport-$POSTFIX" \
    --location $LOCATION \
    --vnet $HUB_VNET_NAME \
    --subnet $HUB_SUBNET_C8KV_TRANSPORT_NAME \
    --network-security-group $NSG_TRANSPORT_NAME \
    --public-ip-address "pip-$C8KV1_NAME-$POSTFIX" \
    --private-ip-address $C8KV1_TRANSPORT_PRIVATE_IP \
    --ip-forwarding true \
    --accelerated-networking true

echo "Creating Service NIC for c8kv-1..."
az network nic create \
    --resource-group $RESOURCE_GROUP \
    --name "nic-$C8KV1_NAME-service-$POSTFIX" \
    --location $LOCATION \
    --vnet $HUB_VNET_NAME \
    --subnet $HUB_SUBNET_C8KV_SERVICE_NAME \
    --network-security-group $NSG_SERVICE_NAME \
    --private-ip-address $C8KV1_SERVICE_PRIVATE_IP \
    --lb-name $ILB_NAME \
    --lb-address-pools "$ILB_BACKEND_POOL_NAME" \
    --ip-forwarding true \
    --accelerated-networking true

#
# C8KV-2
#
echo "Creating Public IP for c8kv-2..."
az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name "pip-$C8KV2_NAME-$POSTFIX" \
    --sku "Standard" \
    --location $LOCATION \
    --allocation-method "Static" \
    --tier "Regional" \
    # --zone 1 2 3


echo "Creating Transport NIC for c8kv-2..."
az network nic create \
    --resource-group $RESOURCE_GROUP \
    --name "nic-$C8KV2_NAME-transport-$POSTFIX" \
    --location $LOCATION \
    --vnet $HUB_VNET_NAME \
    --subnet $HUB_SUBNET_C8KV_TRANSPORT_NAME \
    --network-security-group $NSG_TRANSPORT_NAME \
    --public-ip-address "pip-$C8KV2_NAME-$POSTFIX" \
    --private-ip-address $C8KV2_TRANSPORT_PRIVATE_IP \
    --ip-forwarding true \
    --accelerated-networking true

echo "Creating Service NIC for c8kv-2..."
az network nic create \
    --resource-group $RESOURCE_GROUP \
    --name "nic-$C8KV2_NAME-service-$POSTFIX" \
    --location $LOCATION \
    --vnet $HUB_VNET_NAME \
    --subnet $HUB_SUBNET_C8KV_SERVICE_NAME \
    --network-security-group $NSG_SERVICE_NAME \
    --private-ip-address $C8KV2_SERVICE_PRIVATE_IP \
    --lb-name $ILB_NAME \
    --lb-address-pools "$ILB_BACKEND_POOL_NAME" \
    --ip-forwarding true \
    --accelerated-networking true

#
# Bastion VM
#
echo "Creating Public IP for Bastion VM..."
az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name "pip-$BASTION_NAME-$POSTFIX" \
    --sku "Standard" \
    --location $LOCATION \
    --allocation-method "Static" \
    --tier "Regional" \
    # --zone 1 2 3

echo "Creating NIC for Bastion VM..."
az network nic create \
    --resource-group $RESOURCE_GROUP \
    --name "nic-$BASTION_NAME-$POSTFIX" \
    --location $LOCATION \
    --vnet $HUB_VNET_NAME \
    --subnet $HUB_SUBNET_VM_NAME \
    --public-ip-address "pip-$BASTION_NAME-$POSTFIX" \
    --private-ip-address $BASTION_PRIVATE_IP \
    --accelerated-networking true

#
# Serverfarm VM
#
echo "Creating NIC for ServerFarm VM..."
az network nic create \
    --resource-group $RESOURCE_GROUP \
    --name "nic-$SERVERFARM_NAME-$POSTFIX" \
    --location $LOCATION \
    --vnet $SPOKE_VNET_NAME \
    --subnet $SPOKE_SUBNET_SERVERFARM_NAME \
    --private-ip-address $SERVERFARM_PRIVATE_IP \
    --accelerated-networking true