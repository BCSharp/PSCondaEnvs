<#
.SYNOPSIS
Deactivates an existing conda virtualenv.

.DESCRIPTION
Activate.ps1 and deactivate.ps1 recreates the existing virtualenv BAT files in PS1 format so they "just work" inside a Powershell session.  
#>

Param(
)


if (-not (Test-Path Env:\CONDA_DEFAULT_ENV))
{    
    Write-Host
    Write-Host "No active Conda environment detected."
    Write-Host
    Write-Host "Usage: deactivate"
    Write-Host "Deactivates previously activated Conda environment."
	Write-Host "During deactivation, PS1 scripts in etc\conda\deactivate.d will be run as well."
    Write-Host
    Write-Host
    exit
}

Write-Host
Write-Host "Deactivating environment `"$Env:CONDA_DEFAULT_ENV...`""

$deactivate_d = "${Env:CONDA_PREFIX}\etc\conda\deactivate.d"
if (Test-Path $deactivate_d) {
    Push-Location $deactivate_d
    Get-ChildItem -Filter *.ps1 | select -ExpandProperty FullName  | Invoke-Expression
    Pop-Location
}

# This removes the previous Env from the path and restores the original path
if (Test-Path Env:ANACONDA_BASE_PATH) {
    $Env:PATH = $Env:ANACONDA_BASE_PATH
} else {
    Write-Error "Cannot determine original path, PATH not restored"
}

# Restore original user prompt
if (Test-Path Function:condaUserPrompt) {
    $Function:prompt = $Function:condaUserPrompt
}

# Clean up 
Remove-Item Env:\CONDA_DEFAULT_ENV
Remove-Item Env:\CONDA_PREFIX
Remove-Item Env:\ANACONDA_BASE_PATH
Remove-Item Function:\condaUserPrompt

Write-Host
Write-Host
