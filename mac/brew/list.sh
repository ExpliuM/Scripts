#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

mkdir -p $SCRIPT_DIR/lists

brew list >$SCRIPT_DIR/lists/list
brew list --cask >$SCRIPT_DIR/lists/cask_list