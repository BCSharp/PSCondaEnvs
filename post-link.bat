@echo off
copy NUL %PREFIX%\.messages.txt

powershell -Command "Get-ExecutionPolicy"  > tmp_stdout.txt
set /p VAR=<tmp_stdout.txt
IF NOT "%var%"=="RemoteSigned" (
    IF NOT "%var%"=="Unrestricted" (
        echo WARNING: Your ExecutionPolicy is not configured for 'activate' and 'deactivate' under Powershell. >> %PREFIX%\.messages.txt
        echo You can reconfigure your ExecutionPolicy by executing the following command: >> %PREFIX%\.messages.txt
        echo. >> %PREFIX%\.messages.txt
        echo Powershell -c Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser >> %PREFIX%\.messages.txt
        echo. >> %PREFIX%\.messages.txt
        echo. >> %PREFIX%\.messages.txt
    )
)

DEL tmp_stdout.txt

echo Use 'activate ^<envname^>' or 'deactivate ^<envname^>' in Powershell to manage the current environment. >> %PREFIX%\.messages.txt