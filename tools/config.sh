#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

#////////////////////////////////

# Create the agentlist file
if [ -f agentlist ]; then
    rm agentlist
fi
if [ -f masterlist ]; then
    rm masterlist
fi

tput setaf 1; echo 'Creating the agentlist file...' ; tput sgr0
dcos node | awk '{print $2}' | tail -n +2 > agentlist
tput setaf 1; echo 'Creating the masterlist file...' ; tput sgr0
dig master.mesos +short > masterlist