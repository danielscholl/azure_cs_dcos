#!/bin/bash

echo 'This will deploy a 3 node mongoDB cluster to your DCOS cluster'
echo 'Make sure you are connected to the cluster via ssh'
echo ''
sleep 5
dcos marathon app add mongo-node1.json
dcos marathon app add mongo-node2.json
dcos marathon app add mongo-node3.json
echo ''
echo 'Waiting 20 seconds for the mongo nodes to spin up'
echo ''
sleep 20
echo 'Deploying the cluster initialization app container'
echo ''
dcos marathon app add mongo-cluster-init.json
echo ''
echo 'Waiting 10 seconds for the cluster to initialize'
sleep 10
echo ''
echo 'Destroying cluster initialization container'
dcos marathon app remove /db/mongo/mongo-cluster-init
echo ''
echo 'Check the logs in Mesos to make sure your mongo cluster has initialized properly'
