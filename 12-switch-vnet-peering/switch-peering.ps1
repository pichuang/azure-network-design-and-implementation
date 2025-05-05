$SubscriptionIdorName = "ai-cbkDrill-prd"
$RESOURCE_GROUP = "ai.cbkdrill.prd-twhub-rg"
$DB_VNET_NAME = "ai.cbkdrill.prd-db-tw-vnet"
$PRD_VNET_NAME = "ai.cbkdrill.prd-tw-vnet"
$ISOLIATED_VNET_NAME = "ai.cbkdrill.prd-isolated-tw-vnet"

Write-Host "請選擇要建立的 VNet Peering："
Write-Host "1. 平時抄寫用: ai.cbkdrill.prd-db-tw-vnet <---> ai.cbkdrill.prd-tw-vnet"
Write-Host "2. 孤島演練用: ai.cbkdrill.prd-db-tw-vnet <---> ai.cbkdrill.prd-isolated-tw-vnet"
$choice = Read-Host "輸入選擇 (1 or 2)"

Write-Host "切換到訂閱：$SubscriptionIdorName"
az account set --subscription $SubscriptionIdorName
if ($LASTEXITCODE -ne 0) {
    Write-Host "切換訂閱失敗，程式結束"
    exit 1
}

switch ($choice) {
    "1" {
        Write-Host "移除 $DB_VNET_NAME 與 $ISOLIATED_VNET_NAME 之間的 VNet Peering (若存在)..."
        az network vnet peering delete `
            --name "$DB_VNET_NAME-to-$ISOLIATED_VNET_NAME" `
            --resource-group $RESOURCE_GROUP `
            --vnet-name $DB_VNET_NAME `
            --output none

        az network vnet peering delete `
            --name "$ISOLIATED_VNET_NAME-to-$DB_VNET_NAME" `
            --resource-group $RESOURCE_GROUP `
            --vnet-name $ISOLIATED_VNET_NAME `
            --output none

        Write-Host "建立 $DB_VNET_NAME 與 $PRD_VNET_NAME 之間的 VNet Peering..."
        az network vnet peering create `
            --name "$DB_VNET_NAME-to-$PRD_VNET_NAME" `
            --resource-group $RESOURCE_GROUP `
            --vnet-name $DB_VNET_NAME `
            --remote-vnet $PRD_VNET_NAME `
            --allow-vnet-access `
            --allow-forwarded-traffic `
            --use-remote-gateways `
            --output none

        az network vnet peering create `
            --name "$PRD_VNET_NAME-to-$DB_VNET_NAME" `
            --resource-group $RESOURCE_GROUP `
            --vnet-name $PRD_VNET_NAME `
            --remote-vnet $DB_VNET_NAME `
            --allow-vnet-access `
            --allow-forwarded-traffic `
            --allow-gateway-transit `
            --output none

        Write-Host "$DB_VNET_NAME 與 $PRD_VNET_NAME 之間的 VNet Peering 已成功建立！"
    }
    "2" {
        Write-Host "移除 $DB_VNET_NAME 與 $PRD_VNET_NAME 之間的 VNet Peering (若存在)..."
        az network vnet peering delete `
            --name "$DB_VNET_NAME-to-$PRD_VNET_NAME" `
            --resource-group $RESOURCE_GROUP `
            --vnet-name $DB_VNET_NAME `
            --output none

        az network vnet peering delete `
            --name "$PRD_VNET_NAME-to-$DB_VNET_NAME" `
            --resource-group $RESOURCE_GROUP `
            --vnet-name $PRD_VNET_NAME `
            --output none

        Write-Host "建立 $DB_VNET_NAME 與 $ISOLIATED_VNET_NAME 之間的 VNet Peering..."
        az network vnet peering create `
            --name "$DB_VNET_NAME-to-$ISOLIATED_VNET_NAME" `
            --resource-group $RESOURCE_GROUP `
            --vnet-name $DB_VNET_NAME `
            --remote-vnet $ISOLIATED_VNET_NAME `
            --allow-vnet-access `
            --allow-forwarded-traffic `
            --output none

        az network vnet peering create `
            --name "$ISOLIATED_VNET_NAME-to-$DB_VNET_NAME" `
            --resource-group $RESOURCE_GROUP `
            --vnet-name $ISOLIATED_VNET_NAME `
            --remote-vnet $DB_VNET_NAME `
            --allow-vnet-access `
            --allow-forwarded-traffic `
            --output none

        Write-Host "$DB_VNET_NAME 與 $ISOLIATED_VNET_NAME 之間的 VNet Peering 已成功建立！"
    }
    Default {
        Write-Host "選項無效或未實作的功能。"
    }
}