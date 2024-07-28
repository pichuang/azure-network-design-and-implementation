#!/bin/bash

source ./vars.sh

echo "Creating Route Table for Serverfarm..."
az network route-table create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --name "$RT_HUB_NAME"

echo "Config route via the Azure Firewall..."
az network route-table route create \
    --resource-group $RESOURCE_GROUP \
    --route-table-name "$RT_HUB_NAME" \
    --name "route-to-azfw" \
    --address-prefix "0.0.0.0/0" \
    --next-hop-type "VirtualAppliance" \
    --next-hop-ip-address "$AZFW_PRIVATE_IP"

echo "Associate the route table to the subnet..."
az network vnet subnet update \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $SPOKE_VNET_NAME \
    --name $SPOKE_SUBNET_SERVERFARM_NAME \
    --route-table "$RT_HUB_NAME"

echo "Creating Route Table for AzFW..."
az network route-table create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --name "$RT_AZFW_NAME"

# Message: Route Table rt-azfw-sea on firewall subnet AzureFirewallSubnet must have 0.0.0.0/0 route with next hop Internet.
echo "Config route via the Internet..."
az network route-table route create \
    --resource-group $RESOURCE_GROUP \
    --route-table-name "$RT_AZFW_NAME" \
    --name "route-to-internet" \
    --address-prefix "0.0.0.0/0" \
    --next-hop-type "Internet"

echo "Config 168.95.1.1/32 route via the Internal Load Balancer..."
az network route-table route create \
    --resource-group $RESOURCE_GROUP \
    --route-table-name "$RT_AZFW_NAME" \
    --name "route-to-ilb" \
    --address-prefix "168.95.1.1/32" \
    --next-hop-type "VirtualAppliance" \
    --next-hop-ip-address "$ILB_FRONTEND_PRIVATE_IP"

echo "Config 8.8.8.8/32 route via the Internal Load Balancer..."
az network route-table route create \
    --resource-group $RESOURCE_GROUP \
    --route-table-name "$RT_AZFW_NAME" \
    --name "route-to-ilb-2" \
    --address-prefix "8.8.8.8/32" \
    --next-hop-type "VirtualAppliance" \
    --next-hop-ip-address "$ILB_FRONTEND_PRIVATE_IP"

echo "Associate the route table to the subnet..."
az network vnet subnet update \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $SPOKE_VNET_NAME \
    --name $SPOKE_SUBNET_AZFW_NAME \
    --route-table "$RT_AZFW_NAME"