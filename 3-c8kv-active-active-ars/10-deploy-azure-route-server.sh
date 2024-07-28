#!/bin/bash

source ./vars.sh

echo "Creating Public IP for ars..."
az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name "$ARS_PIP_NAME" \
    --sku "Standard" \
    --location $LOCATION \
    --allocation-method "Static" \
    --tier "Regional"
    # --zone 1 2 3

# query ID of the subnet
ARS_SUBNET_ID=$(az network vnet subnet show \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $HUB_VNET_NAME \
    --name $HUB_SUBNET_ARS_NAME \
    --query "id" \
    --output tsv)
echo "ARS_SUBNET_ID: $ARS_SUBNET_ID"

echo "Creating Azure Route Server..."
az network routeserver create \
    --resource-group $RESOURCE_GROUP \
    --name $ARS_NAME \
    --public-ip-address $ARS_PIP_NAME \
    --hosted-subnet $ARS_SUBNET_ID \
    --hub-routing-preference "ASPath" \
    --location $LOCATION

# query ID of the ARS
ARS_ID=$(az network routeserver show \
    --resource-group $RESOURCE_GROUP \
    --name $ARS_NAME \
    --query "id" \
    --output tsv)
echo "ARS_ID: $ARS_ID"

echo "Updating for Azure Route Server..."
az network routeserver update \
    --ids $ARS_ID \
    --allow-b2b-traffic "true"

echo "Creating peering for Azure Route Server..."
az network routeserver peering create \
    --resource-group $RESOURCE_GROUP \
    --routeserver $ARS_NAME \
    --name "peer-$C8KV1_NAME" \
    --peer-asn $C8KV1_ASN \
    --peer-ip $C8KV1_SERVICE_PRIVATE_IP \

az network routeserver peering create \
    --resource-group $RESOURCE_GROUP \
    --routeserver $ARS_NAME \
    --name "peer-$C8KV2_NAME" \
    --peer-asn $C8KV2_ASN \
    --peer-ip $C8KV2_SERVICE_PRIVATE_IP \
