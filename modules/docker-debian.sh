#!/bin/bash
# See https://docs.docker.com/engine/installation/linux/debian/

set -euxo pipefail

apt-get install -y --no-install-recommends \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common

curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -

# TODO really should check
# apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D

add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       debian-$(lsb_release -cs) \
       main"

apt-get update
apt-get install docker-engine

# Store images on usr partition rather than root
mkdir -p /usr/local/lib/docker
mkdir -p /etc/systemd/system/docker.service.d/

cat <<EOF > /etc/systemd/system/docker.service.d/debian-vm.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -g /usr/local/lib/docker
EOF

if hash pip 2>/dev/null; then
    pip install docker-compose
fi

systemctl enable docker
systemctl start docker
