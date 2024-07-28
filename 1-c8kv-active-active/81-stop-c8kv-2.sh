#!/bin/bash

source ./vars.sh

az vm deallocate \
    --resource-group $RESOURCE_GROUP \
    --name $C8KV2_NAME