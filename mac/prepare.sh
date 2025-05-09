#!/bin/bash

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

./$SCRIPT_PATH/../git/config.sh
./$SCRIPT_PATH/brew/install.sh
./$SCRIPT_PATH/nvm/install.sh