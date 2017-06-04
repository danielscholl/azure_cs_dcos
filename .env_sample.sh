# Sample .env.sh file

export AZURE_SUBSCRIPTION=<your_subscription_id>
export DNS_PREFIX=<unique_dns_prefix>  # If you change this be sure to update the params.json file
export AZURE_RESOURCE_GROUP=personal-cloud  # If you change this be sure to update the params.json file
export AZURE_LOCATION=southcentralus
export AZURE_STORAGE_ACCOUNT=${DNS_PREFIX}${AZURE_RESOURCE_GROUP}storage
export AZURE_REGISTRY=${DNS_PREFIX}${AZURE_RESOURCE_GROUP}
export USER=azureuser  # If you change this be sure to update the ansible.cfg file

## Master & Agent FQDNs
export MASTER_FQDN=${DNS_PREFIX}-${AZURE_RESOURCE_GROUP}-mgmt.${AZURE_LOCATION}.cloudapp.azure.com
export AGENT_FQDN=${DNS_PREFIX}-${AZURE_RESOURCE_GROUP}-agents.${AZURE_LOCATION}.cloudapp.azure.com

