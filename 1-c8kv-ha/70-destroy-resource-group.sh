#!/bin/bash

source ./vars.sh

az group delete \
    --name $RESOURCE_GROUP \
    --yes \
    --no-wait