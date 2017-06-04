#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"
INVENTORY_FILE="inventory"

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
      --template-file deploy.json \
      --parameters @params.json
	else
		echo "Mesos Cluster ${AZURE_RESOURCE_GROUP} already exists."
	fi

#Create the Inventory file
if [ ! -f ${INVENTORY_FILE} ]
  then
    tput setaf 1; echo 'Creating the ansible inventory file...' ; tput sgr0
    echo "[jumpbox]" > ${INVENTORY_FILE}
    echo ${MASTER_FQDN} >> ${INVENTORY_FILE}
  else
    echo "Inventory File Already exists"
  fi

# Provision the JumpBox
ansible-playbook -i ${INVENTORY_FILE} pb.jumpserver.yml
