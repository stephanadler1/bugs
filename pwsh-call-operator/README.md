# pwsh-call-operator

*4 May 2024.*

> ✅ ***SOLVED: A change in the default behavior in PowerShell Core was introduced with version 7.3.
  It switched the default mode that was used to pass arguments to external/native commands from
  the now 'Legacy' mode to a new mode. The details of this change can be found in
  [Using Experimental Features in PowerShell / PSNativeCommandArgumentPassing](https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.4#psnativecommandargumentpassing).***
>
> ***The section calls out that this is a breaking change, however the breaks can happen in very subtle and
  non-obvious ways, so that discovering, debugging and fixing these is not straight-forward.
  And it is referenced in an article called
  [Using Experimental Features in PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.4)
  which I wouldn't even have looked at if not for references in other PowerShell issues below.***


-------------------------------------------------


* Related AzCopy GitHub [issue #796](https://github.com/Azure/azure-storage-azcopy/issues/796) and the [corresponding comment](https://github.com/Azure/azure-storage-azcopy/issues/796#issuecomment-2094342928).
* Related Pwsh GitHub issue: [None found](https://github.com/PowerShell/PowerShell/issues).

There are related topics being discussed on the PowerShell issue tracker though:

* #18991 [Introduce a new cmdlet for calls to native (external) programs ](https://github.com/PowerShell/PowerShell/issues/18991)
* #18961 [Enhance Invoke-Command with parameters that provide ad-hoc overrides of $PSNativeCommandArgumentPassing and $PSNativeCommandUseErrorActionPreference](https://github.com/PowerShell/PowerShell/issues/18961#issuecomment-1386218069)
* #21570 [Proposed command Invoke-Process - to solve common problems with Start-Process -Wait and stream redirection](https://github.com/PowerShell/PowerShell/issues/21570)

## Preparation

In order for the AzCopy tests to execute you need an [Azure Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview): General-purpose v2 LRS is sufficient.
Follow the preparation steps in [azcopy-call-operator.ps1](./azcopy-call-operator.ps1)!

## Testing

Run the tests by invoking `execute-tests.cmd` from your command shell. It doesn't matter whether it is PowerShell Desktop, Core or the legacy Windows Command shell.

## Expected Results

* **git-call-operator.ps1:** The result should be that the commit hash of tag `pwsh-test-tag-1` is returned in all cases: `c849f18f5839d10936311b2163804cb36bbc88e7`.

* **azcopy-call-operator.ps1:** The resulting content of the Azure Storage Account folder should be the same in all cases, only file `the-only-file-that-should-exist.txt` should be uploaded.

    * The test generates different folders per shell (pwsh, powershell) that is being used to that you can examine the actual contents that is being uploaded.
    * For reference it also creates subfolders `mitigated\pwsh` and `mitigated\powershell` that show the content when the crude mitigation is being applied.




## Tested Versions

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
