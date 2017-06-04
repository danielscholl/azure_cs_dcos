#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

#////////////////////////////////
echo 'Connecting to' $HOST
echo ''
echo 'You can connect to DCOS at http://localhost:8080'
echo ''
echo 'You can connect to Mesos at http://localhost:8080/mesos/'
echo ''
echo 'You can connect to Marathon at http://localhost:8080/marathon'
echo ''
ssh -i ./.ssh/id_rsa $USER@$MASTER_FQDN -A -p 2200 -L 8080:localhost:80
