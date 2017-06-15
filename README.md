# PSCondaEnvs

Implementation of Conda's activate/deactivate functions in Powershell.
Works with Anaconda 4.8.3, and presumably newer.


## Installation

Copy `activate.ps1` and `deactivate.ps1` into your Anaconda\Scripts directory.

## Usage

Always use command names with the `.ps1` extension. 
Although PowerShell prefers `.ps1` over `.bat`, when creating a new environment, conda copies `activate.bat` and `deactivate.bat` to `Scripts` dierctory of the new environment, which will be earlier on the search path than the `.ps1` scripts. Therefore: 
```
PS C:\> activate.ps1 TestEnv
[TestEnv] PS C:\> deactivate.ps1
```

For fine control of activation, individual environment `activate.ps1` will execute any `.ps1` scripts in `etc\conda\activate.d\` in the target environment just as `activate.bat` would do with `.bat` scripts.
Similarly, `deactivate.ps1` exetutes sctipts in `etc\conda\deactivate.d\`

## Caveats

* `Activate.ps1` uses internal conda commands `..checkenv` and `..activate` (just as `activate.bat` does). Thinks may stop working when conda changes the semantics of those commands. Also, older versions of conda (probably) do not support those commands.
* Original `activate.bat` and `deactivate.bat` preserves changes in PATH environment variable done by the user while an environment was activated. This is not fully implemented yet (TODO in deactivate.ps1).

## Credits

* Original Conda batch files.
* <https://github.com/Liquidmantis/PSCondaEnvs> (for older Anaconda versions, no support for multiple envs locations)
