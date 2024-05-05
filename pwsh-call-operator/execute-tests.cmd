cls
set "_DEBUG=1"

@echo:
@echo ***
@echo *** Demonstrate argument issues with AzCopy.
@echo ***
@echo:
call pwsh.exe -nologo -noprofile -executionPolicy RemoteSigned -mta -file "%~dp0azcopy-call-operator.ps1" %*
call powershell.exe -nologo -noprofile -executionPolicy RemoteSigned -mta -file "%~dp0azcopy-call-operator.ps1" %*

@echo:
@echo ***
@echo *** Demonstrate argument issues with Git.
@echo ***
@echo:
call pwsh.exe -nologo -noprofile -executionPolicy RemoteSigned -mta -file "%~dp0git-call-operator.ps1" %*
call powershell.exe -nologo -noprofile -executionPolicy RemoteSigned -mta -file "%~dp0git-call-operator.ps1" %*
