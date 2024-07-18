#!/bin/bash

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <org> <repo> <token>"
    exit 1
fi

if [[ $2 == "tiflash-cse" ]]; then
    ./run.tiflash.sh "$@"
else
    ./run.other.sh "$@"
fi
