#!/bin/bash

source ./vars.sh

#
# Deploy c8kv-1 VM in Zone 1
#
echo "Deploying c8kv-1 VM in Zone 1..."
az vm create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --name $C8KV1_NAME \
    --size "$VM_SIZE" \
    --nics "nic-$C8KV1_NAME-transport-$POSTFIX" "nic-$C8KV1_NAME-service-$POSTFIX" \
    --image "$SKU_IMAGE" \
    --authentication-type "password" \
    --admin-username "$ADMIN_USERNAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --custom-data c8kv-1-custom-data.txt \
    --zone 1

#
# Deploy c8kv-2 VM in Zone 3
#
echo "Deploying c8kv-2 VM in Zone 3..."
az vm create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --name $C8KV2_NAME \
    --size "$VM_SIZE" \
    --nics "nic-$C8KV2_NAME-transport-$POSTFIX" "nic-$C8KV2_NAME-service-$POSTFIX" \
    --image "$SKU_IMAGE" \
    --authentication-type "password" \
    --admin-username "$ADMIN_USERNAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --custom-data c8kv-2-custom-data.txt \
    --zone 3