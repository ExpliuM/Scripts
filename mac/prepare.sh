#!/bin/bash

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

./$SCRIPT_PATH/../git/git_config.sh
./$SCRIPT_PATH/brew/install.sh