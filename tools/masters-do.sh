#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

#////////////////////////////////
PDSH_SSH_ARGS_APPEND="-i ~/.ssh/id_rsa" pdsh -l $USER -R ssh -w ^masterlist "$@"