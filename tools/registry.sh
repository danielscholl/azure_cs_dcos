#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

tput setaf 1; echo 'This will enable the Docker daemons in the cluster to connect to registry.marathon.mesos:5000'

# Distribute the insecureRegistry.sh script to all nodes in the cluster.
IFS=$'\n'
FILE1=agentlist
hosts1=`cat $FILE1`

for line in $hosts1;
do
  /usr/bin/scp insecureRegistry.sh $line:~
done

pdsh -R ssh -w  ^agentlist  "sudo chmod 744 insecureRegistry.sh && sudo ./insecureRegistry.sh"