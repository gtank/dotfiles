#!/bin/bash
# Installs docker and sets the daemon to start at boot

set -euxo pipefail

dnf install -y docker docker-compose
mkdir -p /usr/local/lib/docker

# Store docker images somewhere better for Qubes. This allows you to use
# the private storage to avoid always nuking the dmroot space with docker
# images.
cat <<EOF > /etc/sysconfig/docker
# Modify these options if you want to change the way the docker daemon runs
OPTIONS='--selinux-enabled --log-driver=journald -g /usr/local/lib/docker'
DOCKER_CERT_PATH=/etc/docker

# Enable insecure registry communication by appending the registry URL
# to the INSECURE_REGISTRY variable below and uncommenting it
# INSECURE_REGISTRY='--insecure-registry '

# On SELinux System, if you remove the --selinux-enabled option, you
# also need to turn on the docker_transition_unconfined boolean.
# setsebool -P docker_transition_unconfined

# Location used for temporary files, such as those created by
# docker load and build operations. Default is /var/lib/docker/tmp
# Can be overriden by setting the following environment variable.
# DOCKER_TMPDIR=/var/tmp

# Controls the /etc/cron.daily/docker-logrotate cron job status.
# To disable, uncomment the line below.
# LOGROTATE=false
EOF

systemctl enable docker
systemctl start docker
