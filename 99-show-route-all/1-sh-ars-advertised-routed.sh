#!/bin/bash

ROUTE_SERVER_ID=${1:-"/subscriptions/ccbaf256-59c9-4146-a5fa-043af46baa36/resourceGroups/Yageo-Hub-RG/providers/Microsoft.Network/virtualHubs/ars-yageo"}


az network routeserver peering list-advertised-routes --ids ${ROUTE_SERVER_ID} --name ars-yageo-velodedge