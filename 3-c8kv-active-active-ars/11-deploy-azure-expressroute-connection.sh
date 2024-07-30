#!/bin/bash

source ./vars.sh

echo "Create ExpressRoute Gateway Connection"
az network vpn-connection create \
    --name "ExpressRouteConnection" \
    --resource-group $RESOURCE_GROUP \
    --vnet-gateway1 $ERGW_NAME \
    --express-route-circuit2 $ER_CIRCUIT_PEERING_ID \
    --express-route-gateway-bypass "false" \
    --location $LOCATION

    # az network express-route gateway connection create
    # --gateway-name MyGateway -n MyExpressRouteConnection
    # -g MyResourceGroup
    # --peering /subscriptions/MySub/resourceGroups/MyResourceGroup/providers/Microsoft.Network/expressRouteCircuits/MyCircuit/peerings/AzurePrivatePeering

    # az network express-route gateway connection create
    # --gateway-name MyGateway
    # --name MyExpressRouteConnection
    # --peering /subscriptions/MySub/resourceGroups/MyResourceGroup/provi ders/Microsoft.Network/expressRouteCircuits/MyCircuit/peerings/AzurePrivatePeering --resource-group MyResourceGroup