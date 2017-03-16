#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

# Setup Constants
KEY_VAULT=${DNS_PREFIX}-KeyVault


if [[ ! ${AZURE_RESOURCE_GROUP} || ! ${AZURE_LOCATION} ]]
	then
		echo 'ERROR:  *** Environment Variable AZURE_RESOURCE_GROUP or AZURE_LOCATION not set **'
		exit 0
	fi

echo "Creating Azure Storage Elements..."
azure keyvault create --vault-name ${KEY_VAULT} --resource-group ${AZURE_RESOURCE_GROUP}  --location ${AZURE_LOCATION}
azure keyvault set-policy ${KEY_VAULT} --enabled-for-template-deployment true