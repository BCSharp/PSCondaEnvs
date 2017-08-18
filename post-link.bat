@echo off
copy NUL %PREFIX%\.messages.txt

FOR /F "delims=" %%i IN ('CALL powershell.exe -Command Get-ExecutionPolicy') DO SET var=%%i
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

echo Use 'activate ^<envname^>' or 'deactivate ^<envname^>' in Powershell to manage the current environment. >> %PREFIX%\.messages.txt
