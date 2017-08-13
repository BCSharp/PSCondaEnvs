<#
.SYNOPSIS
Activates a Conda virtual environment.

.DESCRIPTION
Deactivates previously activated Conda environment if any, then activates the chosen one.
During activation, PS1 scripts in etc/conda/activate.d will be run as well.

Note that there may be several directories in which envs are stored.
When Anaconda is installed by the Visual Studio Installer,
one location is in the Anaconda installation dir/envs (may be read-only for the current user), 
another one in $HOME/.conda/envs.

The command does not produce any output on success.
Use parameter -Verbose to trace the execution.

.PARAMETER Name 
Name of a virtual enviroment created by conda.  Not specifying this will activate the 'root'
environment.

.NOTES
Tested with Anaconda 4.3.8

Modifies the search PATH variable.

Creates the following environment variables: 
    CONDA_DEFAULT_ENV : name of the active environment
    CONDA_PREFIX      : path to the root directory of the environment

Creates the following PS variables:
    CondaEnvPaths     : array of search paths added during activation

Creates the following functions:
    CondaUserPrompt   : saved original user prompt

.LINK
deactivate.ps1
https://github.com/BCSharp/PSCondaEnvs

.EXAMPLE
PS C:> activate TestEnv
(TestEnv) PS C:>

This command activates a Conda environment named "TestEnv".
Any previously active Conda environment will be deactivated.

#>

Param(
    [string] $Name = "root"
)

# fix for pre-PS3
if (-not $PSScriptRoot) { 
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent 
}


Write-Verbose "Ensure that path or name passed is valid before deactivating anything"
if ($IsOSX -or $IsLinux) {
    $shellType = 'bash'
} else {
    $shellType = 'cmd.exe'
}
conda '..checkenv' $shellType $Name
if (-not $?) {
    Write-Host "Environment not changed." -ForegroundColor Red
    exit 
}

# Deactivate a previous activation if it is live
if (Test-Path Env:CONDA_DEFAULT_ENV) {
    Write-Verbose "Deactivate current environment ""$Env:CONDA_DEFAULT_ENV""..."
    deactivate.ps1 -Hold
}

Write-Verbose "Activating environment ""$Name""..."
$newPath = (conda '..activate' $shellType $Name)
if (-not $?)
{
    Write-Host 'Environment not activated.' -ForegroundColor Red
    exit 
}
$global:CondaEnvPaths = $newPath -split ';'
Write-Verbose 'Activated environment requires the following search paths:'
Write-Verbose ('-' * 20)
$CondaEnvPaths | Write-Verbose
Write-Verbose ('-' * 20)

$Env:CONDA_DEFAULT_ENV = $Name

# Do we have CONDA_PATH_PLACEHOLDER in PATH?
$pathSep = [System.IO.Path]::PathSeparator
$pathArray = $Env:PATH -split $pathSep
$hasPlaceholder = $pathArray -contains "CONDA_PATH_PLACEHOLDER"
# look if the deactivate script left a placeholder for us.
if ($hasPlaceholder) {
    # If it did, replace it with our newPath
    Write-Verbose 'Insert new environment paths into $PATH where previous environment paths were...'
    $Env:PATH = ($pathArray | ForEach-Object {$_ -replace 'CONDA_PATH_PLACEHOLDER',$newPath}) -join $pathSep
} else {
    # If it did not, prepend newPath
    Write-Verbose 'Prepend new environment paths to $PATH...'
    $Env:PATH = $newPath + $pathSep + $Env:PATH
}
Write-Verbose 'Modified $PATH is:'
Write-Verbose ('-' * 20)
$Env:PATH -split $pathSep | Write-Verbose
Write-Verbose ('-' * 20)

# always store the full path to the environment, since location of CONDA_DEFAULT_ENV varies
$Env:CONDA_PREFIX = $CondaEnvPaths[0]

Write-Verbose 'Capture existing user prompt...'
function global:CondaUserPrompt {''}
$Function:CondaUserPrompt = $Function:prompt

Write-Verbose 'Set up environment-specific prompt...'
function global:prompt
{
    # Add the env name to the current user prompt.
    "($Env:CONDA_DEFAULT_ENV) " + (CondaUserPrompt)
}

# Run any activate scripts
$activate_d = "${Env:CONDA_PREFIX}/etc/conda/activate.d"
if (Test-Path $activate_d) {
    Push-Location $activate_d
    # If in Windows, we allow backwards compatibility to run .bat files.  This relies upon 
    # the Invoke-CmdScript by John Robbins.  The version provided maintains PS 2.0 compatibility
    if (-not ($IsOSX -or $IsLinux)) {
        $loadBatFiles = $FALSE
        # If WintellectPowerShell module installed use that
        $CmdScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "invoke_cmdscript.ps1"
        if (Get-Command Invoke-CmdScript -CommandType Function -errorAction SilentlyContinue ) {
            $loadBatFiles = $TRUE
        } elseif ([System.IO.File]::Exists("$CmdScriptPath")) {
            . $CmdScriptPath
            $loadBatFiles = $TRUE
        } else {
            Write-Verbose "Invoke-CmdScript function not available! .bat files won't run"
        }
        if ($loadBatFiles) {
            Write-Verbose "Running .bat activate scripts in '$activate_d'..."
            $bats = Get-ChildItem -Filter *.bat | Select-Object -ExpandProperty FullName
            foreach ($bat in $bats) {
                Invoke-CmdScript $bat
            }
        }
    }
    Write-Verbose "Running .ps1 activate scripts in '$activate_d'..."
    Get-ChildItem -Filter *.ps1 | Select-Object -ExpandProperty FullName | Invoke-Expression

    Pop-Location
}

# Because Conda won't propogate activate.ps1 or deactivate.ps1 throughout all environments automatically,
# we add an alias to override any .bat or .sh files that might try to be executed instead.
if(!(Get-Alias -name activate*)) {
    New-Alias activate activate.ps1 -Scope Global
}
    
if(!(Get-Alias -name deactivate*)) {
    New-Alias deactivate deactivate.ps1 -Scope Global
}