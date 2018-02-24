#!/bin/bash
GENESIS_BLOCK="26313f37e5c18d9208750be9c54e1732dc2d3c53223d48fee171acfebb07e147"
GENESIS_TX="fe75686c319672a04500a89326ff7f0236cef69e7cff9965dd7df4aa273f08b7"
ADDRESS="EbpF6NXRWgXFmFQWqRbqNL3vzudeMqR84c"

DBUSER="dbuser"
DBPASS="dbpass"
DBNAME="blockexplorerdatabase"

RPCUSER="GERyFX9Fu3IPiE7a"
RPCPASS="2LMNh4PKq2aVT39NdtwGDIQr9QCC4cJOnCzfVbEthwc3FLn6TSYqhT4jpbRbKMpU"
RPCPORT="9999"

apt-get -y install libkrb5-dev
apt-get -y install build-essential

apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
apt-get update
apt-get -y install mongodb-org=2.6.3 mongodb-org-server=2.6.3 mongodb-org-shell=2.6.3 mongodb-org-mongos=2.6.3 mongodb-org-tools=2.6.3
# Lock this version, do not update
echo "mongodb-org hold" | dpkg --set-selections
echo "mongodb-org-server hold" | dpkg --set-selections
echo "mongodb-org-shell hold" | dpkg --set-selections
echo "mongodb-org-mongos hold" | dpkg --set-selections
echo "mongodb-org-tools hold" | dpkg --set-selections
# Start mongodb service
service mongod start

wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
echo "export NVM_DIR='$HOME'/.nvm" >> ~/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install 4.0
nvm use 4.0

git clone https://github.com/iquidus/explorer
cd explorer && npm install --production
cp ./settings.json.template ./settings.json

sed -i "s|127.0.0.1:3001|127.0.0.1:80|g" settings.json
sed -i "s|3001|80|g" settings.json
sed -i "s|Darkcoin|Elicoin|g" settings.json
sed -i "s|DRK|ELI|g" settings.json
sed -i "s|1337|0|g" settings.json
sed -i "s|1733320247b15ca2262be646397d1ffd6be953fa638ebb8f5dcbb4c2b91b34f1|$GENESIS_BLOCK|g" settings.json
sed -i "s|f270cd3813254c9922a2e222a56ba745842d9112223a1394062e460b33d27b7e|$GENESIS_TX|g" settings.json
sed -i "s|b2926a56ca64e0cd2430347e383f63ad7092f406088b9b86d6d68c2a34baef51|$GENESIS_BLOCK|g" settings.json
sed -i "s|65f705d2f385dc85763a317b3ec000063003d6b039546af5d8195a5ec27ae410|$GENESIS_TX|g" settings.json
sed -i "s|RBiXWscC63Jdn1GfDtRj8hgv4Q6Zppvpwb|$ADDRESS|g" settings.json

sed -i "s|iquidus|$DBUSER|g" settings.json
sed -i "s|3xp!0reR|$DBPASS|g" settings.json
sed -i "s|explorerdb|$DBNAME|g" settings.json

sed -i "s|darkcoinrpc|$RPCUSER|g" settings.json
sed -i "s|123gfjk3R3pCCVjHtbRde2s5kzdf233sa|$RPCPASS|g" settings.json
sed -i "s|9332|$RPCPORT|g" settings.json

cat >> database.js <<EOF
use $DBNAME
db.createUser( { user: "$DBUSER", pwd: "$DBPASS", roles: [ "readWrite" ] } )
EOF

mongo < database.js
