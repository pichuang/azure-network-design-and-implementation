#!/bin/bash

source ./vars.sh

# Create Public IP for ExpressRoute Gateway
az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name "$ERGW_PIP_NAME" \
    --location $LOCATION \
    --sku "Standard" \
    --allocation-method "Static" \
    --tier "Regional"
    # --zone 1 2 3

# Create ExpressRoute Gateway for Hub VNet
az network vnet-gateway create \
    --resource-group $RESOURCE_GROUP \
    --name "$ERGW_NAME" \
    --location $LOCATION \
    --vnet $HUB_VNET_NAME \
    --gateway-type "ExpressRoute" \
    --public-ip-address "$ERGW_PIP_NAME" \
    --sku "Standard"