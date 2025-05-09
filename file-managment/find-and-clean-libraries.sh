#!/bin/bash

# Script data
SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_NAME=$(basename "$0")

pushd "$SCRIPT_DIR" || exit

# Logs
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$SCRIPT_DIR/logs/$SCRIPT_NAME.log"

mkdir -p "$LOG_DIR"

# Arguments
args=("$@")
folder=${args[0]}

# flags
clean=false
help=false
log=false
print=false

# Parse flags
while [[ "$#" -gt 0 ]]; do
    case "$1" in
    -c | --clean)
        clean=true
        ;;
    -h | --help)
        help=true
        ;;
    -l | --log)
        log=true
        ;;
    -p | --print)
        print=true
        ;;
    --) # end of options
        shift
        break
        ;;
    -*)
        echo "Unknown option: $1" >&2
        exit 1
        ;;
    *) # positional arguments
        ;;
    esac
    shift
done

[ "$print" = "true" ] && echo "help: $help"
[ "$print" = "true" ] && echo "log: $log"
[ "$print" = "true" ] && echo "print: $print"

# Main
while IFS='' read -r line; do
    if [[ -n "$line" ]]; then
        directories+=("$line")
    fi
done < \
    <(
        find "${folder}" \
            \( -not -path "*/.git/*" -a -not -path "*/env/*" -a -not -path "*/.venv/*" \) \
            \( -name "dist" -o -name "node_modules" -o -name "build" -o -name "debug" \) \
            -type d \
            -prune
    )

# Print directories
[ "$print" = "true" ] && for dir in "${directories[@]}"; do
    echo "$dir"
done

totalSize=0
for dir in "${directories[@]}"; do
    size=$(du -sk "$dir" | cut -f1 | awk '{print $1 * 1024}')

    totalSize=$((totalSize + size))

    # Clean
    if [ "$clean" = "true" ]; then
        rm -rf "$dir"
    fi
done

totalCleanSize=$(numfmt --to=iec "$totalSize")
if [ "$clean" = "true" ]; then
    echo "Total $totalCleanSize of data was cleaned from your system"
else
    echo "We can clean up to $totalCleanSize from your system"
fi

popd || exit # $SCRIPT_DIR
