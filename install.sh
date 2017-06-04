#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

# if [ ! -d "tmp" ]; then
#   mkdir tmp
# fi
# if [ ! -d "apps" ]; then
#   mkdir apps
#   cp tools/apps/registry_sample.json apps/registry.json
#   cp tools/app/test_web_app.json app/test_web.json
#   cp tools/app/vendor_db_cassandra_group.json app/vendor_db_cassandra.json
# fi

#az login
az account set \
  --subscription ${AZURE_SUBSCRIPTION}

## Create Resource Group
RESULT=$(az group show --name ${AZURE_RESOURCE_GROUP})
if [ "$RESULT"  == "" ]
	then
		az group create \
      --location ${AZURE_LOCATION} \
      --name ${AZURE_RESOURCE_GROUP}
	else
		echo "Storage account ${AZURE_RESOURCE_GROUP} already exists."
	fi

## Create Storage Account
RESULT=$(az storage account show --name ${AZURE_STORAGE_ACCOUNT} --resource-group ${AZURE_RESOURCE_GROUP} )
if [ "$RESULT"  == "" ]
	then
		az storage account create \
      --name ${AZURE_STORAGE_ACCOUNT} \
      --resource-group ${AZURE_RESOURCE_GROUP} \
      --location ${AZURE_LOCATION} \
      --sku Standard_LRS \
      --kind storage
	else
		echo "Storage account ${AZURE_STORAGE_ACCOUNT} already exists."
	fi

# Create Container Registry
RESULT=$(az acr show --name ${AZURE_REGISTRY} --resource-group ${AZURE_RESOURCE_GROUP} )
if [ "$RESULT"  == "" ]
	then
		az acr create \
      --name ${AZURE_REGISTRY} \
      --resource-group ${AZURE_RESOURCE_GROUP} \
      --location ${AZURE_LOCATION} \
      --storage-account-name ${AZURE_STORAGE_ACCOUNT} \
      --sku Basic \
      --admin-enabled true
	else
		echo "Docker Registry ${AZURE_REGISTRY} already exists."
	fi

# Create Mesos Cluster
RESULT=$(az group deployment show --name Template.Deploy.${AZURE_RESOURCE_GROUP} --resource-group ${AZURE_RESOURCE_GROUP} )
if [ "$RESULT"  == "" ]
	then
		az group deployment create \
      --name Template.Deploy.${AZURE_RESOURCE_GROUP} \
      --resource-group ${AZURE_RESOURCE_GROUP} \
      --template-file templates/acs_dcos.json \
      --parameters @params.json
	else
		echo "Mesos Cluster ${AZURE_RESOURCE_GROUP} already exists."
	fi

# Create the agentlist file
if [ -f tools/agentlist ]; then
    rm tools/agentlist
fi
if [ -f tools/masterlist ]; then
    rm tools/masterlist
fi

if command -v dcos > /dev/null 2>&1; then
  echo "dcos is available"
else
  echo "dcos is not available"
fi

tput setaf 1; echo 'Creating the agentlist file...' ; tput sgr0
dcos node | awk '{print $2}' | tail -n +2 > tools/agentlist
ssh -p 2200 -i ./.ssh/id_rsa $USER@$MASTER0_FQDN  "dig master.mesos +short" > tools/masterlist
