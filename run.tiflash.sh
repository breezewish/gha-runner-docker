#!/bin/bash

set -euo pipefail

echo "Github Runner for $(hostname)"

docker buildx build -t gha-runner .
docker buildx build -t gha-runner-tiflash -f Dockerfile.tiflash .
docker run -ti --name=gha-runner-$1-$2 -d --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v tiflash_cargo_registry:/home/docker/.cargo/registry \
    -v tiflash_cargo_git:/home/docker/.cargo/git \
    -v tiflash_rustup:/home/docker/.rustup \
    -v tiflash_ccache:/home/docker/.cache/ccache \
    -v tiflash_git:/home/docker/actions-runner/_work/tiflash-cse \
    gha-runner-tiflash $1 $2 $3 "$(hostname)"
