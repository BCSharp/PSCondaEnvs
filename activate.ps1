<#
.SYNOPSIS
Activates a conda virtualenv.

.DESCRIPTION
Activate.ps1 and deactivate.ps1 recreates the existing virtualenv BAT files in PS1 format so they "just work" inside a Powershell session.  
Note that on Windows there may be several directories in which envs are stored.
One under the Anaconda installation dir\envs (may be read-only for the current user), another one under $HOME\.conda\envs.
More locations can be configured in $HOME\.condarc

Tested with Anaconda 4.3.8
#>

Param(
    [string]$condaNewEnv
)

if (-not $condaNewEnv)
{
    Write-Host
    Write-Host "Usage: activate.ps1 <envname>"
    Write-Host
    Write-Host "Deactivates previously activated Conda environment, then activates the chosen one."
    Write-Host "During activation, PS1 scripts in etc\conda\activate.d will be run as well."
    Write-Host
    Write-Host
    exit
}

# Ensure that path or name passed is valid before deactivating anything
conda "..checkenv" "cmd.exe" "$condaNewEnv"
if (-not $?)
{
    Write-Host 'Environment not changed.'
    exit 
}

# Deactivate a previous activation if it is live
if (Test-Path Env:\CONDA_DEFAULT_ENV) {
    Invoke-Expression deactivate.ps1
}

Write-Host
Write-Host "Activating environment `"$condaNewEnv...`""
$newPath = (conda "..activate" "cmd.exe" "$condaNewEnv")
if (-not $?)
{
    Write-Host 'Environment not activated.'
    exit 
}
$Env:CONDA_DEFAULT_ENV = $condaNewEnv

# Do we have CONDA_PATH_PLACEHOLDER in PATH?
$pathArray = $Env:PATH -split ';'
$hasPlaceholder = $pathArray -contains 'CONDA_PATH_PLACEHOLDER'
# look if the deactivate script left a placeholder for us.
if ($hasPlaceholder) {
    # If it did, replace it with our newPath
    $Env:PATH = ($pathArray |% {$_ -replace "CONDA_PATH_PLACEHOLDER","$newPath"}) -join ';'
    # Save original path
    $Env:ANACONDA_BASE_PATH = ($pathArray |? {$_ -ne "CONDA_PATH_PLACEHOLDER"}) -join ';'
} else {
    # If it did not, save old path, prepend newPath
    $Env:ANACONDA_BASE_PATH = $Env:PATH
    $Env:PATH="$newPath;$Env:ANACONDA_BASE_PATH"    
}

# always store the full path to the environment, since CONDA_DEFAULT_ENV varies
$Env:CONDA_PREFIX = ($newPath -split ';')[0]

Write-Host
Write-Host

# Capture existing user prompt
function global:condaUserPrompt {''}
$Function:condaUserPrompt = $Function:prompt

function global:prompt
{
    # Add the env name to the current user prompt.
    Write-Host "[$Env:CONDA_DEFAULT_ENV] " -nonewline -ForegroundColor Red
    & $Function:condaUserPrompt
}

# Run any activate scripts
$activate_d = "${Env:CONDA_PREFIX}\etc\conda\activate.d"
if (Test-Path $activate_d) {
    Push-Location $activate_d
    Get-ChildItem -Filter *.ps1 | select -ExpandProperty FullName | Invoke-Expression
    Pop-Location
}
