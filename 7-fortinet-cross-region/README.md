# FortiGate Cross Region with BGP Exchange

## Overview

This example demonstrates how to deploy FortiGate in two different regions and connect them with BGP.

## Step

1. Deploy base resource without FortiGate
```
terraform init
terraform plan
terraform apply --auto-approve
```

2. Deploy FortiGate in each region

    1. Open Azure Marketplace and launch FortiGate Standalone VM. [Link][1]
        ![](../img/7-azuremarketplace-fortigate-standalone-vm.png)

    2. Use FortiGate `Single VM` module to deploy FortiGate in each region manually.




[1]: https://azuremarketplace.microsoft.com/en-us/marketplace/apps/fortinet.fortinet-fortigate?tab=overview
