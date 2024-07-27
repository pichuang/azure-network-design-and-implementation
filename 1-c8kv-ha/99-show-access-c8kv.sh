#!/bin/bash

source ./vars.sh

az network public-ip list \
    --resource-group $RESOURCE_GROUP \
    --output table \
    --query "[].{Name:name, IP:ipAddress}"

echo Username: $ADMIN_USERNAME
echo Password: $ADMIN_PASSWORD