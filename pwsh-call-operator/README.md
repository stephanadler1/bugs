# pwsh-call-operator

*4 May 2024.*

* Related AzCopy GitHub [issue #796](https://github.com/Azure/azure-storage-azcopy/issues/796) and the [corresponding comment](https://github.com/Azure/azure-storage-azcopy/issues/796#issuecomment-2094342928).
* Related Pwsh GitHub issue: [None found](https://github.com/PowerShell/PowerShell/issues).

## Preparation

In order for the AzCopy tests to execute you need an [Azure Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview): General-purpose v2 LRS is sufficient.
Follow the preparation steps in [azcopy-call-operator.ps1](./azcopy-call-operator.ps1)!

## Test

Run the tests by invoking `execute-tests.cmd` from your command shell. It doesn't matter whether it is PowerShell Desktop, Core or the legacy Windows Command shell.


### Tested Versions

| Application        | Executable     | Version                      |
|--------------------|----------------|------------------------------|
| PowerShell Core    | pwsh.exe       | 7.4.2                        |
| PowerShell Desktop | powershell.exe | 5.1.19041.4291               |
| AzCopy             | azcopy.exe     | azcopy version 10.24.0       |
| Git                | git.exe        | git version 2.44.0.windows.1 |

### Operating System

```
OS Name:                   Microsoft Windows 10 Pro
OS Version:                10.0.19045 N/A Build 19045
OS Manufacturer:           Microsoft Corporation
OS Configuration:          Member Workstation
OS Build Type:             Multiprocessor Free
Hotfix(s):                 44 Hotfix(s) Installed.
                           [01]: KB5036618
                           [02]: KB5027122
                           [03]: KB4561600
                           [04]: KB4562830
                           [05]: KB4570334
                           [06]: KB4577266
                           [07]: KB4577586
                           [08]: KB4580325
                           [09]: KB4586864
                           [10]: KB4589212
                           [11]: KB4593175
                           [12]: KB4598481
                           [13]: KB5000736
                           [14]: KB5003791
                           [15]: KB5011048
                           [16]: KB5012170
                           [17]: KB5015684
                           [18]: KB5036892
                           [19]: KB5006753
                           [20]: KB5007273
                           [21]: KB5009636
                           [22]: KB5011352
                           [23]: KB5011651
                           [24]: KB5014032
                           [25]: KB5014035
                           [26]: KB5014671
                           [27]: KB5015895
                           [28]: KB5016705
                           [29]: KB5018506
                           [30]: KB5020372
                           [31]: KB5022924
                           [32]: KB5023794
                           [33]: KB5025315
                           [34]: KB5026879
                           [35]: KB5028318
                           [36]: KB5028380
                           [37]: KB5029709
                           [38]: KB5031539
                           [39]: KB5032392
                           [40]: KB5032907
                           [41]: KB5034224
                           [42]: KB5036447
                           [43]: KB5037018
                           [44]: KB5005699
Hyper-V Requirements:      A hypervisor has been detected. Features required for Hyper-V will not be displayed.
```
