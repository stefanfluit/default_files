#!/usr/bin/env bash

set -o errexit      #Exit on uncaught errors

declare USER_="fluit"
declare BACKUP_DIR="/home/fluit/Documents/scripts/default_files/terminal_files_fluit/backup_${DATE_STAMP}"

mkdir "${BACKUP_DIR}"

# Define how many daily backups you want to keep. 
declare retention_days="7"

declare DATE_STAMP
DATE_STAMP="$(date +%m-%d-%Y)"

declare -a base_files=(
    "/home/${USER_}/.zshrc"
    "/home/${USER_}/.p10k.zsh"
)

dconf dump /com/gexperts/Tilix/ > "${BACKUP_DIR}/tilix.dconf"

for file in "${base_files[@]}"; do
    cp "${file}" "${BACKUP_DIR}"
done

cd "${BACKUP_DIR}"

git add "${BACKUP_DIR}/.zshrc" && git commit -m "Backup of ${DATE_STAMP} for .zshrc."

git add "${BACKUP_DIR}/tilix.dconf" && git commit -m "Backup of ${DATE_STAMP} for tilix conf."

git add "${BACKUP_DIR}/.p10k.zsh" && git commit -m "Backup of ${DATE_STAMP} for p10k config."

cd "${BACKUP_DIR}" && GIT_SSH_COMMAND='ssh -i  /home/fluit/.ssh/id_ed25519_git.pub' git push