#!/bin/bash
#set -o errexit -o pipefail

ENV_SETUP=".env.sh"
source "$ENV_SETUP"

# Build and Push the Image
npm run registry:start
docker build mongo
docker build -t localhost:5000/mongo:latest .
docker push localhost:5000/mongo:latest
npm run registry:stop