@echo off
cls
set "_SHELLS=pwsh.exe powershell.exe"

echo:
echo ***
echo *** Demonstrate argument issues with AzCopy.
echo ***

for %%s in (%_SHELLS%) do (
    echo:
    echo ***
    echo *** %%s
    echo ***
    echo:
    call %%s -nologo -noprofile -executionPolicy RemoteSigned -mta -file "%~dp0azcopy-call-operator.ps1" %*
)


echo:
echo ***
echo *** Demonstrate argument issues with Git.
echo ***

for %%s in (%_SHELLS%) do (
    echo:
    echo ***
    echo *** %%s
    echo ***
    echo:
    call %%s -nologo -noprofile -executionPolicy RemoteSigned -mta -file "%~dp0git-call-operator.ps1" %*
)
