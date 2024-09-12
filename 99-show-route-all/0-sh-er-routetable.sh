#!/bin/bash

#
# Set the ER circuit ID
#
ER_CIRCUIT_ID=${1:-"/subscriptions/0a4374d1-bc72-46f6-a4ae-a9d8401369db/resourceGroups/rg-hub-er-taiwannorth/providers/Microsoft.Network/expressRouteCircuits/er-standard-50Mbps-taiwannorth"}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ER_CIRCUIT_ID>"
    echo "  ER_CIRCUIT_ID: The Resource ID of the ExpressRoute circuit"
    exit 1
else
    echo
    echo "== Show the current routing table of an ExpressRoute circuit peering. "
    echo
fi
#
# Show the route table for the primary and secondary paths
#
PRIMARY_PATH_ID="${ER_CIRCUIT_ID}/peerings/AzurePrivatePeering/path/primary"
echo "=== Primary Route: ${PRIMARY_PATH_ID}"
az network express-route list-route-tables --ids ${PRIMARY_PATH_ID} -o json --only-show-errors |
jq -r '.value[] | "\(.network) \(.nextHop) \(.path)"' |
awk 'BEGIN {print "network nextHop path"} {print}' |
column -t
echo "=== End of Primary Route ==="
echo

SECONDARY_PATH_ID="${ER_CIRCUIT_ID}/peerings/AzurePrivatePeering/path/secondary"
echo "=== Secondary Path: ${SECONDARY_PATH_ID}"
az network express-route list-route-tables --ids ${SECONDARY_PATH_ID} -o json --only-show-errors |
jq -r '.value[] | "\(.network) \(.nextHop) \(.path)"' |
awk 'BEGIN {print "network nextHop path"} {print}' |
column -t
echo "=== End of Secondary Route ==="
