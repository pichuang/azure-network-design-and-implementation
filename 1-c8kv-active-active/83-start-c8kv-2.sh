#!/bin/bash

source ./vars.sh

az vm start \
    --resource-group $RESOURCE_GROUP \
    --name $C8KV2_NAME