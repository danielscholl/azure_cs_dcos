#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"


# Create the agentlist file
if [ -f tools/agentlist ]; then
    rm tools/agentlist
fi
if [ -f tools/masterlist ]; then
    rm tools/masterlist
fi

tput setaf 1; echo 'Creating the agentlist file...' ; tput sgr0
dcos node | awk '{print $2}' | tail -n +2 > tools/agentlist
ssh -p 2200 -i ./.ssh/id_rsa $USER@$MASTER0_FQDN  "dig master.mesos +short" > tools/masterlist

echo ''
tput setaf 1; echo 'Installing pdsh on the master for parallel cluster management'; tput sgr0
echo ''
# Install pdsh on the master
ssh -p 2200 -i ./.ssh/id_rsa $USER@$MASTER0_FQDN  "sudo apt-get update"
ssh -p 2200 -i ./.ssh/id_rsa $USER@$MASTER0_FQDN  "sudo apt-get install -y pdsh libssl-dev ansible"


tput setaf 1; echo 'Copying files up to the Master \n' ; tput sgr0

# Copy the ssh key up to the Master
scp -i ./.ssh/id_rsa -P 2200 ./.ssh/id_rsa ${USER}@${MASTER0_FQDN}:/home/${USER}/.ssh/
scp -i ./.ssh/id_rsa -P 2200  ./config/sshconfig.conf ${USER}@${MASTER0_FQDN}:/home/${USER}/.ssh/config
ssh -p 2200 -i ./.ssh/id_rsa ${USER}@${MASTER0_FQDN}  "chmod 600 /home/${USER}/.ssh/id_rsa"

# Create Tools
ssh -p 2200 -i ./.ssh/id_rsa ${USER}@${MASTER0_FQDN}  "mkdir ~/tools"
scp -i ./.ssh/id_rsa -P 2200 ./.env.sh ${USER}@${MASTER0_FQDN}:/home/${USER}/tools  # Copy Environment File
scp -i ./.ssh/id_rsa -P 2200 ./tmp/agentlist ./tmp/masterlist ${USER}@${MASTER0_FQDN}:/home/${USER}/tools  # Copy MasterList and AgentList
scp -i ./.ssh/id_rsa -P 2200 -r tools/* ${USER}@${MASTER0_FQDN}:/home/${USER}/tools # Copy Tools

# Copy Templates


# ////////////////////////////////////// ONE TIME RUN HACK /////////////////////////////////////////////////////////////////
# Fix funny errors with libcrypto linking against the mesos libraries.
#ssh -p 2200 -i ./.ssh/id_rsa $USER@$MASTER0_FQDN  "echo LD_LIBRARY_PATH=/lib/x86_64-linux-gnu >> /home/${USER}/.bashrc"
