#!/bin/bash

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <org> <repo> <token>"
    exit 1
fi

echo "Github Runner for $(hostname)"

if [[ $2 == "tiflash-cse" ]]; then

    docker run -ti --name=gha-runner-$1-$2 -d --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v tiflash_cargo_registry:/home/docker/.cargo/registry \
        -v tiflash_cargo_git:/home/docker/.cargo/git \
        -v tiflash_rustup:/home/docker/.rustup \
        -v tiflash_ccache:/home/docker/.cache/ccache \
        -v tiflash_git:/home/docker/actions-runner/_work/tiflash-cse \
        hub.pingcap.net/sunxiaoguang/serverless/gha-runner:tiflash-latest \
        /bin/bash -l -c "./start.sh $1 $2 $3 $(hostname)"

else

    docker run -ti --name=gha-runner-$1-$2 -d --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        hub.pingcap.net/sunxiaoguang/serverless/gha-runner:latest \
        /bin/bash -l -c "./start.sh $1 $2 $3 $(hostname)"

fi
