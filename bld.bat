echo %PREFIX%
if not exist "%PREFIX%" mkdir %PREFIX%
if not exist "%PREFIX%\Scripts" mkdir %PREFIX%\Scripts
COPY activate.ps1 %PREFIX%\Scripts\activate.ps1
COPY deactivate.ps1 %PREFIX%\Scripts\deactivate.ps1
