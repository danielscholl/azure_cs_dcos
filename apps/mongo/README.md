# MongoDB 3 node replicaset

This will create a 3 node mongodb replicaset in your ACS cluster.

To create this cluster, we need to build a custom MongoDB image which adds an init script that allows the MongoDB replicaset to be initialized without having to enter any of the mongo containers.

## Create Custom Mongo Image

First, make sure that your local registry is running (`npm run registry:start`) and pointed to the same backing storage as the registry in the DCOS cluster.

Then run the following:

``` bash
cd Docker
./buildimage.sh
```

This should build and push the custom image to the private registry.

## Deploy the MongoDB containers

To Deploy the cluster, after building the custom image, simply run `deploy-mongo.sh`.  This will spin up 3 nodes of Mongo, wait for them to fully initialize, deploy a 4th app to tell those Mongo Containers to link up as a replica set, and then destroy the cluster-init app.

## Technical Notes

These apps are binding the MongoDB Containers to host port 27107. This allows the Mongo containers to correctly resolve each other with mesos-dns, and also prevents the individual containers from running on the same node (since port 27017 will be taken on other nodes).  This also allows for direct connections to the database containers, bypassing marathon-lb (although you could still connect to the containers via marathon-lb if you want to, just assign a service port).

I am not binding any kind of persistent storage.  If you wish to use persistent storage, either pin each container to a particular node and map local storage or map the container to azure backing storage using the azure Docker storage driver.
