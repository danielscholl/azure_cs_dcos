#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

if (whoami != root)
  then echo "Please run as root"
  exit 0
fi

# Setup Constants
SYSTEMD_PATH='/etc/systemd/system'
SETTINGS_PATH='/etc/default'


echo 'Getting Azure Docker Volume Driver'
wget -O azurefile-dockervolumedriver $(curl -s https://api.github.com/repos/Azure/azurefile-dockervolumedriver/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4)
mv azurefile-dockervolumedriver /usr/bin/
chmod +x /usr/bin/azurefile-dockervolumedriver

echo ' '
echo 'Creating Azure Docker Volume Driver Settings in ${SETTINGS_PATH}/azurefile-dockervolumedriver'
touch ${SETTINGS_PATH}/azurefile-dockervolumedriver

cat <<EOT >> ${SETTINGS_PATH}/azurefile-dockervolumedriver
Environment file for azurefile-dockervolumedriver.service
#
# AF_OPTS=--debug
 
AZURE_STORAGE_ACCOUNT=${AZURE_STG_ACCOUNT_NAME}
AZURE_STORAGE_ACCOUNT_KEY=${AZURE_STG_ACCOUNT_KEY}
EOT



echo ' '
echo 'Creating systemd service definition at ${SYSTEMD_PATH}/azurefile-dockervolumedriver.service'
touch ${SYSTEMD_PATH}/azurefile-dockervolumedriver.service

cat <<EOT >> 
[Unit]
Description=Azure File Service Docker Volume Driver
Documentation=https://github.com/Azure/azurefile-dockervolumedriver/
Requires=docker.service
After=nfs-utils.service
Before=docker.service
 
[Service]
EnvironmentFile=${SYSTEMD_PATH}/azurefile-dockervolumedriver
ExecStart=/usr/bin/azurefile-dockervolumedriver $AF_OPTS
Restart=always
StandardOutput=syslog

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl enable azurefile-dockervolumedriver
systemctl start azurefile-dockervolumedriver
systemctl status azurefile-dockervolumedriver

docker volume create --name fileshare -d azurefile -o share=fileshare
echo ' '
echo 'Run this command to create a docker volume against an Azure File Share'
echo 'docker volume create --name my_volume -d azurefile -o share=myshare'
