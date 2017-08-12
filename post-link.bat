@echo off
copy NUL %PREFIX%\.messages.txt

powershell -Command "Get-ExecutionPolicy"  > tmp_stdout.txt
set /p VAR=<tmp_stdout.txt
IF NOT "%var%"=="RemoteSigned" (
    IF NOT "%var%"=="Unrestricted" (
        echo WARNING: Your ExecutionPolicy is not configured for 'activate' and 'deactivate' under Powershell.  Attempting to reconfigure... >> %PREFIX%\.messages.txt
        Powershell -c Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser > tmp_stdout.txt
        set /p VAR2=<tmp_stdout.txt
        IF "%var2%"=="" (
            echo ExecutionPolicy has been successfully set to "RemoteSigned" for the CurrentUser! >> %PREFIX%\.messages.txt
        )
        IF NOT "%var2%"=="" (
            echo Setting ExecutionPolicy may have failed.  Please contact your administrator to set the ExecutionPolicy for Powershell. >> %PREFIX%\.messages.txt
        )
        echo. >> %PREFIX%\.messages.txt
        echo. >> %PREFIX%\.messages.txt
    )
)

DEL tmp_stdout.txt

echo Use 'activate ^<envname^>' or 'deactivate ^<envname^>' in Powershell to manage the current environment. >> %PREFIX%\.messages.txt