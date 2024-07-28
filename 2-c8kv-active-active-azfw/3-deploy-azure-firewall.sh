#!/bin/bash

source ./vars.sh

# echo "Creating Azure Firewall Policy..."
# az network firewall policy create \
#     --name "$AZFW_POLICY_NAME" \
#     --resource-group $RESOURCE_GROUP \
#     --location $LOCATION \
#     --auto-learn-private-ranges Enabled \
#     --sku "Standard" \
#     --threat-intel-mode "Off"

# echo "Creating Azure Firewall Network Rule Collection..."
az network firewall policy rule-collection-group create \
    --name "Allow-Any-All" \
    --policy-name "$AZFW_POLICY_NAME" \
    --resource-group $RESOURCE_GROUP \
    --priority 100

echo "Creating Azure Firewall Network Rule..."
az network firewall policy rule-collection-group collection rule add \
    --collection-name "Network-Allow-All" \
    --name "Allow-Any" \
    --policy-name "$AZFW_POLICY_NAME" \
    --rcg-name "Allow-Any-All" \
    --resource-group $RESOURCE_GROUP \
    --rule-type "NetworkRule" \
    --dest-addr "*" \
    --destination-ports "*" \
    --source-addresses "*" \
    --protocols "Any"


# echo "Creating Public IP for Azure Firewall..."
# az network public-ip create \
#     --resource-group $RESOURCE_GROUP \
#     --name $AZFW_PUBLIC_IP_NAME \
#     --sku "Standard" \
#     --location $LOCATION \
#     --allocation-method "Static" \
#     --tier "Regional" \
#     --zone 1 2 3

# echo "Creating Azure Firewall..."
# az network firewall create \
#     --name "$AZFW_NAME" \
#     --location $LOCATION \
#     --resource-group $RESOURCE_GROUP \
#     --firewall-policy $AZFW_POLICY_NAME \
#     --vnet $SPOKE_VNET_NAME \
#     --sku "AZFW_VNet" \
#     --tier "Standard" \
#     --public-ip $AZFW_PUBLIC_IP_NAME \
#     --enable-udp-log-optimization true

