#!/bin/bash

source ./vars.sh

echo "Create Internal Load Balancer"
az network lb create \
    --resource-group $RESOURCE_GROUP \
    --name $ILB_NAME \
    --location $LOCATION \
    --sku "Standard" \
    --frontend-ip-name "$ILB_FRONTEND_NAME" \
    --private-ip-address "$ILB_FRONTEND_PRIVATE_IP" \
    --vnet-name $HUB_VNET_NAME \
    --subnet $HUB_SUBNET_C8KV_SERVICE_NAME \
    --backend-pool-name "$ILB_BACKEND_POOL_NAME"

echo "Create Internal Load Balancer Probe"
az network lb probe create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $ILB_NAME \
    --name "ILBHealthProbe" \
    --protocol tcp \
    --port 80 \
    --interval 5 \
    --probe-threshold 1

echo "Create Internal Load Balancer Rule"
az network lb rule create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $ILB_NAME \
    --name "ILBPortsRule" \
    --protocol All \
    --frontend-port 0 \
    --backend-port 0 \
    --load-distribution SourceIPProtocol \
    --backend-pool-name "$ILB_BACKEND_POOL_NAME" \
    --probe-name "ILBHealthProbe"