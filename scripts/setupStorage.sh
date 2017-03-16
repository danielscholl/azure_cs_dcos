#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

# Setup Constants
CONTAINER=registry
FILESHARE=fileshare


if [[ ! ${AZURE_STORAGE_ACCESS_KEY} ]]
	then
		echo 'ERROR:  *** Environment Variable AZURE_STORAGE_ACCESS_KEY not set **'
    azure storage account keys list ${AZURE_STORAGE_ACCOUNT} -g ${AZURE_RESOURCE_GROUP}
		exit 0
	fi


echo "Creating Azure Storage Elements..."
azure storage container create ${CONTAINER} -p blob
azure storage share create ${FILESHARE}
