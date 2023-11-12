#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

brew list >$SCRIPT_DIR/list
brew list --cask >$SCRIPT_DIR/cask_list