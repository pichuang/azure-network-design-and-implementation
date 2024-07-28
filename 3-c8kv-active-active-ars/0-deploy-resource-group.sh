#!/bin/bash

source ./vars.sh

echo "Setting subscription..."
az account set --subscription $SUBSCRIPTION_ID

echo "Creating resource group..."
az group create --location $LOCATION --name $RESOURCE_GROUP
