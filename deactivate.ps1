<#
.SYNOPSIS
Deactivates an existing Conda virtual environment.

.DESCRIPTION
Deactivates previously activated Conda environment.
During deactivation, PS1 scripts in etc\conda\deactivate.d will be run as well.
If no active environment is present, no action will be taken.

.PARAMETER Hold
Internal use by activate.ps1

.LINK
activate.ps1
https://github.com/BCSharp/PSCondaEnvs

.EXAMPLE
(TestEnv) PS C:> deactivate.ps1
PS C:>

This command deactivates the active Conda environment named "TestEnv".

#>

Param(
    [Switch] $Hold
)


if (-not (Test-Path Env:\CONDA_DEFAULT_ENV))
{    
    Write-Warning "No active Conda environment detected."
    exit
}

Write-Host
Write-Host "Deactivating environment `"$Env:CONDA_DEFAULT_ENV`"..."

$deactivate_d = "${Env:CONDA_PREFIX}\etc\conda\deactivate.d"
if (Test-Path $deactivate_d) {
    Push-Location $deactivate_d
    Get-ChildItem -Filter *.ps1 | select -ExpandProperty FullName  | Invoke-Expression
    Pop-Location
}

# This removes the previous Env from the path and restores the original path
if ($CondaEnvPaths) {
    $Env:PATH = ($Env:PATH -split ';' | where {$_ -notin $CondaEnvPaths}) -join ';'
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
Remove-Item Function:\condaUserPrompt
Remove-Variable CondaEnvPaths -Scope Global

Write-Host
