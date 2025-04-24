#
# 參數設定
#
$SubscriptionIdorName = "subscription-sandbox-any-projects"
$ResourceGroupName = "rg-11-isolated-island"
$SourceVmName = "vm-island-jpe"
$SnapshotDiskName = "snapshot-osdisk-" + (Get-Date -Format "yyyyMMddHHmm")

$TargetVmName = "vm-island-jpe-vnet2"
$TargetDiskSku = "Standard_LRS"
$TargetOsDiskName = "osdisk-from-snapshot-" + (Get-Date -Format "yyyyMMddHHmm")
$TargetVnetName = "vnet-island-b"
$TargetSubnetName = "default"
$TargetNicName = "nic-vnet-2"
$TargetNicIP = "192.168.200.4"

# 設定錯誤處理為 Stop，遇到錯誤立即跳出
$ErrorActionPreference = "Stop"

try {
    # 切換到指定的訂閱
    Write-Host "切換到訂閱：$SubscriptionIdorName"
    az account set --subscription $SubscriptionIdorName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "切換訂閱失敗，程式結束"
        exit 1
    }

    # 取得來源 VM 的 OS 磁碟 ID
    Write-Host "取得來源 VM 的 OS 磁碟 ID：$SourceVmName"
    $osDiskId = az vm show `
      --resource-group $ResourceGroupName `
      --name $SourceVmName `
      --query "storageProfile.osDisk.managedDisk.id" `
      --output tsv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "取得來源 VM 的 OS 磁碟 ID 失敗，程式結束"
        exit 1
    }

    # 檢查 Resource Group 是否存在
    az group show --name $ResourceGroupName | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Resource group '$ResourceGroupName' 不存在，程式結束"
        exit 1
    }

    # 以 OS 磁碟建立 Snapshot
    Write-Host "建立 Snapshot... $SnapshotDiskName"
    az snapshot create `
      --resource-group $ResourceGroupName `
      --name $SnapshotDiskName `
      --source $osDiskId `
      --output none
    if ($LASTEXITCODE -ne 0) {
        Write-Host "建立 Snapshot 失敗，程式結束"
        exit 1
    }

    Write-Host "Snapshot $SnapshotDiskName 建立完成，來源 VM：$SourceVmName"
    Start-Sleep -Seconds 5

    # 以 Snapshot 建立 Managed Disk
    Write-Host "建立 Managed Disk 從 Snapshot... $TargetOsDiskName"
    az disk create `
      --resource-group $ResourceGroupName `
      --name $TargetOsDiskName `
      --source $SnapshotDiskName `
      --sku $TargetDiskSku `
      --output none
    if ($LASTEXITCODE -ne 0) {
        Write-Host "建立 Managed Disk 失敗，程式結束"
        exit 1
    }

    # 建立 VM 所需的 NIC
    Write-Host "建立 NIC... $TargetNicName"
    az network nic create `
      --resource-group $ResourceGroupName `
      --name $TargetNicName `
      --vnet-name $TargetVnetName `
      --subnet $TargetSubnetName `
      --private-ip-address $TargetNicIP `
      --output none
    if ($LASTEXITCODE -ne 0) {
        Write-Host "建立 NIC 失敗，程式結束"
        exit 1
    }

    # 建立 VM 並掛載剛才的 Managed Disk
    Write-Host "建立 VM... $TargetVmName"
    az vm create `
      --resource-group $ResourceGroupName `
      --name $TargetVmName `
      --nics $TargetNicName `
      --attach-os-disk $TargetOsDiskName `
      --os-type Linux `
      --output none
    if ($LASTEXITCODE -ne 0) {
        Write-Host "建立 VM 失敗，程式結束"
        exit 1
    }

    # 啟用 Boot Diagnostics
    Write-Host "啟用 Boot Diagnostics... $TargetVmName"
    az vm boot-diagnostics enable `
      --resource-group $ResourceGroupName `
      --name $TargetVmName `
      --output none
    if ($LASTEXITCODE -ne 0) {
        Write-Host "啟用 Boot Diagnostics 失敗，程式結束"
        exit 1
    }

    Write-Host "新 VM $TargetVmName 建立完成，在 $TargetVnetName 中使用 Snapshot Disk."

    # 取得 VM 的 IP 位址
    $targetIpAddress = az vm list-ip-addresses `
      --resource-group $ResourceGroupName `
      --name $TargetVmName `
      --query "[].virtualMachine.network.privateIpAddresses[]" `
      --output tsv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "取得 VM 的 IP 位址 失敗，程式結束"
        exit 1
    }

    Write-Host "完成 Target VM $TargetVmName 建立，IP 位址：$targetIpAddress"
}
catch {
    Write-Host "發生錯誤：$($_.Exception.Message)"
    exit 1
}
