#!/usr/bin/env bash

set -o errexit      #Exit on uncaught errors

# Finding the directory we're in
declare DIR
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

sudo cp "${DIR}/systemd/backup-files.service" "/etc/systemd/system/backup-files.service" && printf "Copied Sysd unit\n"
sudo cp "${DIR}/systemd/backup-files.timer" "/etc/systemd/system/backup-files.timer" && printf "Copied Sysd unit\n"
sudo systemctl daemon-reload
sudo systemctl enable backup-files.timer --now

sudo mkdir /var/lib/scripts
sudo cp "${DIR}/backup_files.sh" "/var/lib/scripts/backup_files.sh"
sudo chmod +x "/var/lib/scripts/backup_files.sh"
sudo chown -R ${USER_}:${USER_} "/var/lib/scripts"