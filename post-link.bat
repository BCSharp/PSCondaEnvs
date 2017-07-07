powershell -Command "Get-ExecutionPolicy"  > tmp_stdout.txt
set /p VAR=<tmp_stdout.txt
IF NOT "%var%"=="RemoteSigned" (
    IF NOT "%var%"=="Unrestricted" (
        echo WARNING: Your ExecutionPolicy is not configured for 'activate' and 'deactivate' under Powershell.  Please use the 'setup_psconda' command to reconfigure. > %PREFIX%\.messages.txt
    )
)

echo Please use the 'setup_psconda' command to configure the 'pscondaenvs' package as a default Conda package. > %PREFIX%\.messages.txt