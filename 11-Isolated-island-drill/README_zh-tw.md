# 11-Isolated-island-drill

此資料夾包含用於在隔離的 Azure 環境中練習 VM OS 磁碟快照與還原的 Azure CLI 腳本。

## 資料夾結構

- `0-prepare-island-create.azcli`
  用於建立基本的網路與資源群組環境（如 VNet、Subnet 等）。

- [1-create-osdisk-snapshot.azcli](1-create-osdisk-snapshot.azcli)
  從現有的 VM 建立 OS 磁碟快照。
  - 會自動取得 OS 磁碟 ID。
  - 建立名為 `snapshot-osdisk` 的快照。

- [2-create-vm-from-snapshot.azcli](2-create-vm-from-snapshot.azcli)
  使用快照建立新的 managed disk，然後在另一個 VNet 中建立一台新的 VM（並建立新的 NIC）並掛載該磁碟。
  - 新 VM 會有與原始 VM 相同的作業系統內容。

## 使用方式

1. **準備環境**
   執行 `0-prepare-island-create.azcli` 以建立所需的資源群組、VNet 及子網路。

2. **建立 OS 磁碟快照**
   執行 [1-create-osdisk-snapshot.azcli](1-create-osdisk-snapshot.azcli) 來為來源 VM 建立 OS 磁碟快照。

3. **從快照還原 VM**
   執行 [2-create-vm-from-snapshot.azcli](2-create-vm-from-snapshot.azcli) 來：
   - 由快照建立新的 managed disk
   - 在目標 VNet 建立新的 NIC
   - 用新磁碟與 NIC 建立新的 VM

## 先決條件

- 已安裝並登入 Azure CLI (`az login`)
- 需有建立資源的權限
- 資源群組與原始 VM 必須已存在

## 注意事項

- 所有腳本皆以英文註解，方便閱讀。
- 請依需求修改每個腳本最上方的參數（如 VM 名稱、資源群組等）。
- 腳本僅供學習與演練使用，請注意資源用量以避免產生不必要的費用。

---

如果你是 Azure CLI 新手，可以將腳本內容逐行貼到終端機執行，或將 .azcli 檔設為可執行檔後直接執行：

```bash
chmod +x 0-prepare-island-create.azcli
./0-prepare-island-create.azcli
```