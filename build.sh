#!/bin/bash

set -euo pipefail

docker buildx build --progress=plain -t gha-runner-base -f Dockerfile.gha-runner-base .
docker buildx build --progress=plain -t gha-runner -f Dockerfile.gha-runner .
docker buildx build --progress=plain -t gha-runner-tiflash -f Dockerfile.gha-runner-tiflash .

docker image tag gha-runner         hub.pingcap.net/sunxiaoguang/serverless/gha-runner:latest
docker image tag gha-runner-tiflash hub.pingcap.net/sunxiaoguang/serverless/gha-runner:tiflash-latest

docker push hub.pingcap.net/sunxiaoguang/serverless/gha-runner:latest
docker push hub.pingcap.net/sunxiaoguang/serverless/gha-runner:tiflash-latest
