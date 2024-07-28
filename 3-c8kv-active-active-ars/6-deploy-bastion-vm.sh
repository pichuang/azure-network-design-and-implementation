#!/bin/bash

source ./vars.sh

az vm create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --name $BASTION_NAME \
    --size "Standard_D2_v5" \
    --nics "nic-$BASTION_NAME-$POSTFIX" \
    --image "Ubuntu2204" \
    --authentication-type "password" \
    --admin-username "$ADMIN_USERNAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --custom-data bastion-custom-data.txt