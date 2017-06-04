#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

if [ ! -d "tmp" ]; then
  mkdir tmp
fi
if [ ! -d "apps" ]; then
  mkdir apps
  cp tools/apps/registry_sample.json apps/registry.json
  cp tools/app/test_web_app.json app/test_web.json
  cp tools/app/vendor_db_cassandra_group.json app/vendor_db_cassandra.json
fi

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

      DOCKER_SERVER=$(az acr show -n ccitcluster1 --query "loginServer" -o tsv)
      DOCKER_USER=$(az acr credential show -n ccitcluster1 --query "username" -o tsv)
      DOCKER_PASS=$(az acr credential show -n ccitcluster1 --query "passwords[0].value" -o tsv)
      docker login ${DOCKER_SERVER} -u ${DOCKER_USER} -p ${DOCKER_PASS}
	else
		echo "Docker Registry ${AZURE_REGISTRY} already exists."
	fi

# Create Mesos Cluster
RESULT=$(az acs show --name Template.Deploy.${AZURE_RESOURCE_GROUP} --resource-group ${AZURE_RESOURCE_GROUP} )
if [ "$RESULT"  == "" ]
	then
		az group deployment create \
      --name Template.Deploy.${AZURE_RESOURCE_GROUP} \
      --resource-group ${AZURE_RESOURCE_GROUP} \
      --template-file templates/acs_dcos.json \
      --parameters @templates/params.json
	else
		echo "Mesos Cluster ${AZURE_RESOURCE_GROUP} already exists."
	fi
