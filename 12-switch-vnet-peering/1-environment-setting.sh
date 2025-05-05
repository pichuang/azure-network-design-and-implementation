#!/bin/bash
RESOURCE_GROUP="ai.cbkdrill.prd-twhub-rg"
REGION="japaneast"
VNET1_NAME="ai.cbkdrill.prd-db-tw-vnet"
VNET1_PREFIX="192.168.100.0/24"
VNET2_NAME="ai.cbkdrill.prd-tw-vnet"
VNET2_PREFIX="192.168.200.0/24"
VNET3_NAME="ai.cbkdrill.prd-isolated-tw-vnet"
VNET3_PREFIX="192.168.3.0/24"

#
# Execute
#

echo "Creating resource group... $RESOURCE_GROUP"
az group create \
  --name $RESOURCE_GROUP \
  --location $REGION \
  --output none

echo "Creating VNet... $VNET1_NAME"
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET1_NAME \
  --address-prefix $VNET1_PREFIX \
  --subnet-name default \
  --output none

echo "Creating VNet... $VNET2_NAME"
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET2_NAME \
  --address-prefix $VNET2_PREFIX \
  --subnet-name default \
  --output none

echo "Creating VNet... $VNET3_NAME"
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET3_NAME \
  --address-prefix $VNET3_PREFIX \
  --subnet-name default \
  --output none
