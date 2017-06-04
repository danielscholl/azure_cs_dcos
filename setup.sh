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

tput setaf 1; echo 'Creating the masterlist file...' ; tput sgr0
ssh -p 2200 -i ./.ssh/id_rsa $USER@$MASTER0_FQDN  "dig master.mesos +short" > tools/masterlist

if command -v dcos > /dev/null 2>&1; then
  tput setaf 1; echo 'Creating the agentlist file...' ; tput sgr0
  dcos node | awk '{print $2}' | tail -n +2 > tools/agentlist
else
  echo "dcos is not available can't retrieve agentlist'"
fi


