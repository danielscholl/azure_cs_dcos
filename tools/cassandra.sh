#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

#////////////////////////////////


#////////////////////////////////
dcos package install --options=./apps/cassandra.json cassandra --yes