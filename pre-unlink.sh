#!/bin/bash
if [ "$CONDA_DEFAULT_ENV" == "root" ]; then
   conda config --remove create_default_packages pscondaenvs
fi