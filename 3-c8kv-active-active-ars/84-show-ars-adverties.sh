#!/bin/bash

source ./vars.sh

echo "====="
echo "Show peer-$C8KV1_NAME - Azure Route Server Advertised Routes"
echo "====="
az network routeserver peering list-advertised-routes \
    --resource-group $RESOURCE_GROUP \
    --routeserver $ARS_NAME \
    --name "peer-$C8KV1_NAME" \
    --output table

echo "====="
echo "Show peer-$C8KV1_NAME - Azure Route Server Learned Routes"
echo "====="

az network routeserver peering list-learned-routes \
    --resource-group $RESOURCE_GROUP \
    --routeserver $ARS_NAME \
    --name "peer-$C8KV1_NAME" \
    --output table

echo "====="
echo "Show peer-$C8KV2_NAME - Azure Route Server Advertised Routes"
echo "====="
az network routeserver peering list-advertised-routes \
    --resource-group $RESOURCE_GROUP \
    --routeserver $ARS_NAME \
    --name "peer-$C8KV2_NAME" \
    --output table

echo "====="
echo "Show peer-$C8KV2_NAME - Azure Route Server Learned Routes"
echo "====="

az network routeserver peering list-learned-routes \
    --resource-group $RESOURCE_GROUP \
    --routeserver $ARS_NAME \
    --name "peer-$C8KV2_NAME" \
    --output table
