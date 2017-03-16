#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP="./.env.sh"
source "$ENV_SETUP"

#////////////////////////////////
dcos package install --options=./apps/marathon-lb-internal.json marathon-lb --yes
dcos package install --options=./apps/marathon-lb-external.json marathon-lb --yes