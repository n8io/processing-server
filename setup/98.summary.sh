#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"; \

IP=$(curl -s icanhazip.com); \
MSG="
SUMMARY:
  MEDIA MANAGEMENT
    Services are initialized and should be available shortly at the following:
      * http://${IP}:8080  Sabnzbd
      * http://${IP}:8989  Sonarr
      * http://${IP}:7878  Couchpotatos - Releases
      * http://${IP}:7879  Couchpotatos - Prereleases
      * http://${IP}:8091  Transmission
  LOGIN CREDENTIALS
    If any service asks for login credentials, they are \"admin\" and \"12345\".
    It is recommended that you login and change these on first use.
  AMAZON CLOUD DRIVE
    As files are pulled down by your media managers they will be automatically
    encrypted and pushed to your Amazon Cloud Drive at the following directory:
      * ${ENC_DIR_REMOTE} - which can be found at: https://www.amazon.com/clouddrive/folder/root
  \e[33mTHINGS FOR YOU TO CONFIG
    * All media service username and passwords. Do not leave them as default.
    * In Sabnzbd, provide your Usenet creds
    * In Sonarr and both Couchpotatos, provide your indexer(s) creds
  \e[31mENCRYPTION KEY FILES
    You must copy and save the contents of the following items somewhere safe.
    Preferably in a password manager. If you lose these, you will never
    be able to decrypt your data.
      * Encryption password: $(cat $ENCFS_CREDS)
      * Encryption config file: ${ENCFS6_CONFIG}
      * Rclone config file: /root/.rclone.conf

  \e[32mGo and profit.\e[0m

  * For later reference, this output has been saved to: ${CODE_DIR}/summary.txt
"; \
echo -e "${MSG}" | tee "${CODE_DIR}/summary.txt"

set +e
