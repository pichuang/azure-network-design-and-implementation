#!/bin/bash

RESOURCE_GROUP_NAME="rg-hub-er-taiwannorth"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# do not change
ROOT_DIR="backup-routetables-${RESOURCE_GROUP_NAME}-${TIMESTAMP}"
mkdir -p ${ROOT_DIR}

# List all route tables in the resource group, then backup each route table
az network route-table list \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --query "[].{Name:name}" \
    -o tsv > ${ROOT_DIR}/list-rt-${RESOURCE_GROUP_NAME}.tsv

while IFS= read -r line; do
    az network route-table route list \
        --resource-group ${RESOURCE_GROUP_NAME} \
        --route-table-name $line \
        --query "[].{Name:name, AddressPrefix:addressPrefix, NextHopType:nextHopType, NextHopIpAddress:nextHopIpAddress}" \
        -o tsv > ${ROOT_DIR}/${line}-${TIMESTAMP}.tsv
done < ${ROOT_DIR}/list-rt-${RESOURCE_GROUP_NAME}.tsv
