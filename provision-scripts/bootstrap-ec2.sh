#!/bin/sh
set -e

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize our own variables:
HOSTNAME=""
ENVIRONMENT=""

while getopts "h:e:" opt; do
    case "$opt" in
    h)  HOSTNAME=$OPTARG
        ;;
    e)  ENVIRONMENT=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

echo "[INFO]: HOSTNAME=${HOSTNAME}"
echo "[INFO]: ENVIRONMENT=${ENVIRONMENT}"
echo ""

echo "[INFO]: Bootstrap..."

until [ -f "/var/lib/cloud/instance/boot-finished" ]; do
  echo "[INFO]:  - Waiting for cloud-init to finish...sleeping 1 second"
  sleep 1
done

# Set up the hostname
if [ -n "${HOSTNAME}" ]; then
  echo "${HOSTNAME}" > /etc/hostname
  hostname ${HOSTNAME}
fi

# create the student user
echo "student ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/student-users
chmod 440 /etc/sudoers.d/student-users
useradd student || :
mkdir -p /home/student/.ssh
chmod 700 /home/student/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8QdHPv1S9NWitZ0AtHmmR2ZW84BMgV4XzOj5rLU0BVtTXEWk5JzeA544pWnrKRodncPof8G0sIdUR5cLdH+t6SzAJabQ9MlyNlQi69jJ3ZqtKv6Vhuc0YwenJSGR2NM+tAslQP/1RHZiEKWol3UAh11ghvRe1ufib0o4mkKTG+fdfBcGvP2t2nuuqQFrMwKQdho/Kypz2GMvJHFlgH8g/gr1jMj6yNKfpFdViEIcl2xTCeqpd5C7fKveHQxLZ+EclEVNmzSWpenpIO2ujRr2mr/uX01T9mBLHJ8ixCsO2LVC96fKvf0JWVhN2ZrC/Z65XGbAzDrKV9GPIFcGCbE+z student@training' > /home/student/.ssh/authorized_keys
chmod 600 /home/student/.ssh/authorized_keys
chown -R student:student /home/student

# install python if system is ubuntu
if which apt-get; then
    apt-get install python
fi
