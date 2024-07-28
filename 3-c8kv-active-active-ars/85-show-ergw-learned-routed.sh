#!/bin/bash

source ./vars.sh

echo
echo "list of BGP peers for the virtual network gateway"
echo
az network vnet-gateway list-bgp-peer-status \
    --resource-group $RESOURCE_GROUP \
    --name $ERGW_NAME \
    --output table

echo
echo "list of routes the virtual network gateway has learned"
echo
az network vnet-gateway list-learned-routes \
    --resource-group $RESOURCE_GROUP \
    --name $ERGW_NAME \
    --output table