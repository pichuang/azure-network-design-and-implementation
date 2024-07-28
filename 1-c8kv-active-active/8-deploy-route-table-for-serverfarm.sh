#!/bin/bash

source ./vars.sh

echo "Creating Route Table for Serverfarm..."
az network route-table create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --name "$RT_HUB_NAME"

echo "Config route via the internal load balancer..."
az network route-table route create \
    --resource-group $RESOURCE_GROUP \
    --route-table-name "$RT_HUB_NAME" \
    --name "route-to-c8kv-ilb" \
    --address-prefix "0.0.0.0/0" \
    --next-hop-type "VirtualAppliance" \
    --next-hop-ip-address "$ILB_FRONTEND_PRIVATE_IP"


echo "Associate the route table to the subnet..."
az network vnet subnet update \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $SPOKE_VNET_NAME \
    --name $SPOKE_SUBNET_SERVERFARM_NAME \
    --route-table "$RT_HUB_NAME"
