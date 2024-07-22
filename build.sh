#!/bin/bash

set -euo pipefail

ARCH=$(uname -p)

docker buildx build --progress=plain -t gha-runner-base --load -f Dockerfile.gha-runner-base .
docker buildx build --progress=plain -t gha-runner --load -f Dockerfile.gha-runner .
docker buildx build --progress=plain -t gha-runner-tiflash --load -f Dockerfile.gha-runner-tiflash .

docker image tag gha-runner         hub.pingcap.net/sunxiaoguang/serverless/gha-runner:$ARCH-latest
docker image tag gha-runner-tiflash hub.pingcap.net/sunxiaoguang/serverless/gha-runner:$ARCH-tiflash-latest

docker push hub.pingcap.net/sunxiaoguang/serverless/gha-runner:$ARCH-latest
docker push hub.pingcap.net/sunxiaoguang/serverless/gha-runner:$ARCH-tiflash-latest
