# syntax=docker/dockerfile:1

FROM ubuntu:22.04

# set the github runner version
ARG RUNNER_VERSION="2.314.1"
ARG DOCKER_GID="121"

# copy over the start.sh script
WORKDIR /home/docker/actions-runner

RUN \
    --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,sharing=locked,target=/var/lib/apt <<EOF

export DEBIAN_FRONTEND=noninteractive
sed -i s@/archive.ubuntu.com/@/apt.ksyun.cn/@g /etc/apt/sources.list
sed -i s@/ports.ubuntu.com/@/apt.ksyun.cn/@g /etc/apt/sources.list
sed -i s@/security.ubuntu.com/@/apt.ksyun.cn/@g /etc/apt/sources.list
apt-get update -y
apt-get upgrade -y

EOF

RUN \
    --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,sharing=locked,target=/var/lib/apt <<EOF

groupadd -g ${DOCKER_GID} docker
useradd -m docker -g docker

export DEBIAN_FRONTEND=noninteractive ARCH=`dpkg --print-architecture`
apt-get install -y --no-install-recommends \
    curl jq gnupg software-properties-common \
    build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip unzip \
    git cmake protobuf-compiler sudo

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=${ARCH}] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu jammy stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

export ARCH=`dpkg --print-architecture | sed --expression='s/amd/x/g'`
export FILENAME=actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz
curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${FILENAME}
tar xzf ./$FILENAME
chown -R docker /home/docker
./bin/installdependencies.sh

EOF

# Allow sudo without password
RUN <<EOF

echo docker ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/docker
chmod 0440 /etc/sudoers.d/docker

EOF

COPY misc/start.sh /home/docker/actions-runner/start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
