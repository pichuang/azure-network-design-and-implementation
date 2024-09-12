#!/bin/bash

ROUTE_SERVER_ID=${1:-"/subscriptions/0a4374d1-bc72-46f6-a4ae-a9d8401369db/resourceGroups/rg-hub-er-taiwannorth/providers/Microsoft.Network/virtualHubs/ars-taiwannorth"}

az network routeserver peering list-advertised-routes --ids ${ROUTE_SERVER_ID} -o json --only-show-errors


az network routeserver peering list -g rg-hub-er-taiwannorth --routeserver ars-taiwannorth