powershell -Command "Get-ExecutionPolicy"  > tmp_stdout.txt
set /p VAR=<tmp_stdout.txt
IF NOT "%var%"=="RemoteSigned" (
    IF NOT "%var%"=="Unrestricted" (
        set /p ans="WARNING: Your ExecutionPolicy is not configured for 'activate' and 'deactivate' under Powershell.  Would you like to attempt to set ExecutionPolicy to 'RemoteSigned' for the current user to fix this? (y/n)"
        IF "%ans%"=="y" (
            DEL tmp_stdout.txt
            Powershell -c Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser > tmp_stdout.txt
            set /p VAR=<tmp_stdout.txt
            IF NOT "%var%"=="" (
                echo Setting ExecutionPolicy may have failed.  Please contact your administrator to set the ExecutionPolicy for Powershell.
            )
        )
    )
)
DEL tmp_stdout.txt

conda config --get create_default_packages > tmp_stdout.txt
findstr /m "pscondaenvs" tmp_stdout.txt
if NOT %errorlevel%==0 (
    echo Would you like to add the 'pscondaenvs' package to all future environments by default?
    set /p ans="This change won't impact your currently existing environments. (y/n)"
    IF "%ans%"=="y" (
        conda config --add create_default_packages pscondaenvs
    )
)

DEL tmp_stdout.txt