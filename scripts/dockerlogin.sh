#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

DOCKER_SERVER=$(az acr show -n ${AZURE_REGISTRY} --query "loginServer" -o tsv)
DOCKER_USER=$(az acr credential show -n ${AZURE_REGISTRY} --query "username" -o tsv)
DOCKER_PASS=$(az acr credential show -n ${AZURE_REGISTRY} --query "passwords[0].value" -o tsv)
docker login ${DOCKER_SERVER} -u ${DOCKER_USER} -p ${DOCKER_PASS}
# docker logout ${DOCKER_SERVER}
