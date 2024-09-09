#!/bin/bash

ROUTE_SERVER_ID=${1:-"/subscriptions/0a4374d1-bc72-46f6-a4ae-a9d8401369db/resourceGroups/rg-hub-er-taiwannorth/providers/Microsoft.Network/virtualHubs/ars-taiwannorth"}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ROUTE_SERVER_ID>"
    echo "  ROUTE_SERVER_ID: The Resource ID of the Azure Route Server"
    exit 1
else
    echo
    echo "== List all routes the route server bgp connection is advertising to the specified peer. "
    echo
fi

az network routeserver peering list-advertised-routes --ids ${ROUTE_SERVER_ID} -o json --only-show-errors