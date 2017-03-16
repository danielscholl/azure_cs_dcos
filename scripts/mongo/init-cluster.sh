#!/bin/bash


BUILD_JS=start_cluster.js
COUNTER=2
NODE_COUNT="${NODE_COUNT:-3}"
STARTUP_DELAY="${STARTUP_DELAY:-15}"

USER1="${ADMIN_USER:-admin}"
PASS1="${ADMIN_PASS:-password}"

USER2="${ROOT_USER:-root}"
PASS2="${ROOT_PASS:-password}"

echo 'Building '$BUILD_JS' File...'
echo '-----'

###Build js file for Mongo
echo 'rs.initiate();' >> $BUILD_JS
##NOTE: In MongoDB Shell, sleep number is in milliseconds
echo 'sleep(25000)' >> $BUILD_JS
while [  $COUNTER -le $NODE_COUNT ]; do
    echo 'rs.add("'$(eval echo "\${NODE${COUNTER}}" )'");' >> $BUILD_JS
    echo 'sleep(5000)' >> $BUILD_JS
    let COUNTER=COUNTER+1
done
echo 'rs.status();' >> $BUILD_JS

#echo 'db.createUser( { user: "'$USER1'", pwd: "'$PASS1'", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] }); ' >> $BUILD_JS

#echo 'db.createUser( { user: "'$USER2'", pwd: "'$PASS2'", roles: [ { role: "root", db: "admin" } ] });' >> $BUILD_JS


echo $BUILD_JS 'has been built.'
echo '-----'
# echo 'rs.add("'$NODE2'");' >> $BUILD_JS
# echo 'rs.add("'$NODE3'");' >> $BUILD_JS

echo 'Pausing for' $STARTUP_DELAY 'seconds to allow Mongo Nodes to start up...'
echo '-----'
sleep $STARTUP_DELAY

echo 'Initializing Mongo DB Replica Set'

mongo --host $MASTER $BUILD_JS