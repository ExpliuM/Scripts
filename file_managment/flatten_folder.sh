#!/bin/bash

args=("$@")
flattenFolder=${args[0]}
echo "flattenFolder=$flattenFolder"

find "${flattenFolder}" -type f -mindepth 2 -exec mv '{}' "${flattenFolder}" ';'