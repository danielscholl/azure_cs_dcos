#!/bin/bash
#set -o errexit -o pipefail

dcos package install --options=./cassandra/cassandra.json cassandra --yes
dcos package install --options=./marathon/marathon-lb-internal.json marathon-lb --yes
dcos package install --options=./marathon/marathon-lb-external.json marathon-lb --yes
dcos marathon app add ./mongo/mongo-node1.json
dcos marathon app add ./mongo/mongo-node2.json
dcos marathon app add ./mongo/mongo-node3.json
dcos marathon app add ./redis/redis.json
