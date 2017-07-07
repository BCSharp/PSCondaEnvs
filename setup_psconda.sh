#!/bin/bash
if [[ $(conda config --get create_default_packages) != *pscondaenvs* ]]
    echo Would you like to add the 'pscondaenvs' package to all future environments by default?
    read -p "This change won't impact your currently existing environments. (y/n)" yn
    case $yn in
        [Yy]* ) conda config --add create_default_packages pscondaenvs; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
fi