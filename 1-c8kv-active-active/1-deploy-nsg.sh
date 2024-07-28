#!/bin/bash

source ./vars.sh

#
# Create Network Security Group for c8kv transport subnet
#
echo "Creating Network Security Group for c8kv transport subnet..."
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_TRANSPORT_NAME

# Allow Inbound ICMP
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_TRANSPORT_NAME \
    --name "AllowInboundICMP" \
    --direction Inbound \
    --priority 1000 \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges "*" \
    --access Allow \
    --protocol Icmp \
    --description "Allow Inbound ICMP"

# Allow Inbound TCP 22
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_TRANSPORT_NAME \
    --name "AllowInboundSSH" \
    --direction Inbound \
    --priority 1001 \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 22 \
    --access Allow \
    --protocol Tcp \
    --description "Allow Inbound SSH"

# Allow Inbound UDP 12346-13156
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_TRANSPORT_NAME \
    --name "AllowInboundDTLS" \
    --direction Inbound \
    --priority 1002 \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 12346-13156 \
    --access Allow \
    --protocol Udp \
    --description "Allow Inbound UDP 12346-13156"

# Allow Outbound Any
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_TRANSPORT_NAME \
    --name "AllowOutboundAny" \
    --direction Outbound \
    --priority 1000 \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges "*" \
    --access Allow \
    --protocol "*" \
    --description "Allow Outbound Any"

#
# Create Network Security Group for c8kv service subnet
#
echo "Creating Network Security Group for c8kv service subnet..."
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_SERVICE_NAME

# Allow Inbound Any
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_SERVICE_NAME \
    --name "AllowInboundAny" \
    --direction Inbound \
    --priority 1000 \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges "*" \
    --access Allow \
    --protocol "*" \
    --description "Allow Inbound Any"

# Allow Outbound Any
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_SERVICE_NAME \
    --name "AllowOutboundAny" \
    --direction Outbound \
    --priority 1000 \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges "*" \
    --access Allow \
    --protocol "*" \
    --description "Allow Outbound Any"

#
# Create Network Security Group for VM subnet
#
echo "Creating Network Security Group for VM subnet..."
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_VM_NAME

# Allow Inbound Any
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_VM_NAME \
    --name "AllowInboundAny" \
    --direction Inbound \
    --priority 1000 \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges "*" \
    --access Allow \
    --protocol "*" \
    --description "Allow Inbound Any"

# Allow Outbound Any
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_VM_NAME \
    --name "AllowOutboundAny" \
    --direction Outbound \
    --priority 1000 \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges "*" \
    --access Allow \
    --protocol "*" \
    --description "Allow Outbound Any"