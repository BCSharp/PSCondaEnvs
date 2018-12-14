# PSCondaEnvs

Implementation of Conda's activate/deactivate functions in PowerShell.
Works with Anaconda 4.1 and newer.
Works on Windows, macOS, Linux.
Works with PowerShell 2.0 and up.

## Quick Install

Open a Powershell or Command Prompt session, and enter the following command:
```
conda install -n root -c pscondaenvs pscondaenvs
```

Done! Note, you may need to change the Powershell `Execution-Policy` to `RemoteSigned` in order for this package to work.

## Manual Install

If you want to install manually for some reason, copy `activate.ps1`, `deactivate.ps1` and `invoke_cmdscript.ps1` into your Anaconda\Scripts directory (Windows) or `activate.ps1` and `deactivate.ps1` to anaconda/bin directory (macOS, Linux).

## Usage

Simply use the `activate` and `deactivate` commands as normal:
```
PS C:\> activate TestEnv
(TestEnv) PS C:\> deactivate
```

For fine control of activation of an individual environment, `activate.ps1` will execute both `.ps1` and `.bat` scripts in `etc\conda\activate.d\` in the target environment just as `activate.bat` would do with `.bat` scripts.
Similarly, `deactivate.ps1` exetutes sctipts in `etc\conda\deactivate.d\`

For more help:
```
PS C:> help activate.ps1
```

## Caveats

* `Activate.ps1` uses internal conda commands `..checkenv` and `..activate` (just as `activate.bat` does). Things may stop working when conda changes the semantics of those commands. Also, older versions of conda (probably) do not support those commands.
* The names of the scripts do not follow established PowerShell naming convention. Probably more appriopriate names for the sctipts would be `Enable-CondaEnv`/`Disable-CondaEnv`, or, even better: `Enter-CondaEnvironment`/`Exit-CondaEnvironment` (the verbs enable/disable are meant for lifecycle management). Long, but then again: New-Alias is your friend.
* `activate` and `deactivate` Powershell Aliases are automatically added when you first activate your environment.  This is to override any activate/deactivate.bat or .activate/deactivate.sh files that appear in your individual environment's binary path, that would normally execute instead.
* You might no be allowed to execute the PowerShell scripts due to your systems execution policies. A simple, though dangerous, way to circumvent this is to allow the execution of all remoty signed scripts, by running the following command from an Admin-Powershell: `set-executionpolicy remotesigned`. You may need to restart any open Powershell sessions for the change to take effect.

## Credits

* Original Conda batch files.
* <https://github.com/Wintellect/WintellectPowerShell> A modified PS 2.0 compatible `Invoke-CmdScript` is used to maintain .bat backwards compatibility
* <https://github.com/Liquidmantis/PSCondaEnvs> (for older Anaconda versions, no support for multiple envs locations)
