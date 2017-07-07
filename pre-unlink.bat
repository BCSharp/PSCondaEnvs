REM If we're uninstalling from the root environment, we remove our default package installer
if "%CONDA_DEFAULT_ENV%"=="root" (
    conda config --remove create_default_packages pscondaenvs
)
