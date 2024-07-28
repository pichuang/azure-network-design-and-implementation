#!/bin/bash

source ./vars.sh

echo "Creating NIC for ServerFarm VM..."
az vm create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --name $SERVERFARM_NAME \
    --size "Standard_D2_v5" \
    --nics "nic-$SERVERFARM_NAME-$POSTFIX" \
    --image "Ubuntu2204" \
    --authentication-type "password" \
    --admin-username "$ADMIN_USERNAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --custom-data bastion-custom-data.txt

