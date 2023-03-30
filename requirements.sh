
#!/bin/bash

if [  -n "/etc/os-release | grep Ubuntu" ]; then
    echo Ubuntu
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get install jq
else
    echo "Currently onlu ubuntu supported"
fi