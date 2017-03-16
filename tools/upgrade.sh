#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

#////////////////////////////////

pdsh -R ssh -l $USER -w ^agentlist "sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y"
pdsh -R ssh -l $USER -w ^masterlist "sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y"
