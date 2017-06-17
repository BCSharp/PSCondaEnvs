# PSCondaEnvs

Implementation of Conda's activate/deactivate functions in PowerShell.
Works with Anaconda 4.8.3, and presumably newer.


## Installation

Copy `activate.ps1` and `deactivate.ps1` into your Anaconda\Scripts directory.

## Usage

Always use command names with the `.ps1` extension. 
Although PowerShell prefers `.ps1` over `.bat`, when creating a new environment, conda copies `activate.bat` and `deactivate.bat` to `Scripts` directory of the new environment, which will be earlier on the search path than the `.ps1` scripts. Therefore: 
```
PS C:\> activate.ps1 TestEnv
(TestEnv) PS C:\> deactivate.ps1
```

Of course, it is always possible to define aliases, which will take precedence over `.bat` files:
```
PS C:\> nal activate activate.ps1
PS C:\> nal deactivate deactivate.ps1
```
Or use any other name as alias that is less typing but mnemonic enough.

For fine control of activation of an individual environment, `activate.ps1` will execute any `.ps1` scripts in `etc\conda\activate.d\` in the target environment just as `activate.bat` would do with `.bat` scripts.
Similarly, `deactivate.ps1` exetutes sctipts in `etc\conda\deactivate.d\`

For more help:
```
PS C:> help activate -full
```

## Caveats

* `Activate.ps1` uses internal conda commands `..checkenv` and `..activate` (just as `activate.bat` does). Things may stop working when conda changes the semantics of those commands. Also, older versions of conda (probably) do not support those commands.
* Original `activate.bat` and `deactivate.bat` preserves location of Conda environment paths in PATH environment variable when switching to a new environment. This is not fully implemented yet.
* The names of the scripts do not follow established PowerShell naming convention. Probably more appriopriate names for the sctipts would be `Enable-CondaEnv`/`Disable-CondaEnv`, or, even better: `Enter-CondaEnvironment`/`Exit-CondaEnvironment` (the verbs enable/disable are meant for lifecycle management). Long, but then again: New-Alias is your friend.

## Credits

* Original Conda batch files.
* <https://github.com/Liquidmantis/PSCondaEnvs> (for older Anaconda versions, no support for multiple envs locations)
