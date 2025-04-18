# 11-Isolated-island-drill

This folder contains Azure CLI scripts for practicing VM OS disk snapshot and VM restore in an isolated Azure environment.

## Folder Structure

- `0-prepare-island-create.azcli`
  Prepare the basic network and resource group environment (VNet, Subnet, etc.).

- [1-create-osdisk-snapshot.azcli](1-create-osdisk-snapshot.azcli)
  Create a snapshot of the OS disk from an existing VM.
  - Automatically retrieves the OS disk ID.
  - Creates a snapshot named `snapshot-osdisk`.

- [2-create-vm-from-snapshot.azcli](2-create-vm-from-snapshot.azcli)
  Use the snapshot to create a new managed disk, then create a new VM (with a new NIC) in another VNet using that disk.
  - The new VM will have the same OS content as the original VM.

## Usage

1. **Prepare the environment**
   Run `0-prepare-island-create.azcli` to create the required resource group, VNets, and subnets.

2. **Create OS Disk Snapshot**
   Run [1-create-osdisk-snapshot.azcli](1-create-osdisk-snapshot.azcli) to snapshot the OS disk of the source VM.

3. **Restore VM from Snapshot**
   Run [2-create-vm-from-snapshot.azcli](2-create-vm-from-snapshot.azcli) to:
   - Create a new managed disk from the snapshot.
   - Create a new NIC in the target VNet.
   - Create a new VM using the new disk and NIC.

## Prerequisites

- Azure CLI installed and logged in (`az login`)
- Sufficient permissions to create resources in your Azure subscription
- The resource group and original VM must already exist

## Notes

- All scripts use English comments for clarity.
- Modify the parameter section at the top of each script as needed (such as VM name, resource group, etc.).
- Scripts are designed for learning and drill purposes. Please check resource usage to avoid unnecessary costs.

---

If you are new to Azure CLI, you can copy and paste each script line by line into your terminal, or make the [.azcli](cci:7://file:///Users/pichuang/ms-workspace/azure-network-design-and-implementation/11-Isolated-island-drill/1-create-osdisk-snapshot.azcli:0:0-0:0) files executable and run them directly:

```bash
chmod +x 0-prepare-island-create.azcli
./0-prepare-island-create.azcli
```