#!/bin/bash

DBUSER="dbuser"
DBPASS="dbpass"
DBNAME="coiniumdb"

RPCUSER="GERyFX9Fu3IPiE7a"
RPCPASS="2LMNh4PKq2aVT39NdtwGDIQr9QCC4cJOnCzfVbEthwc3FLn6TSYqhT4jpbRbKMpU"
RPCPORT="9999"

MAINMAGIC=`head -c 4 ~/.elicoin/blocks/blk00000.dat |hexdump -e '16/1 "%02x" "\n"'`
elicoin-cli stop
elicoind -daemon -testnet
sleep 10
TESTMAGIC=`head -c 4 ~/.elicoin/testnet4/blocks/blk00000.dat |hexdump -e '16/1 "%02x" "\n"'`
elicoin-cli stop
elicoind -daemon
sleep 5

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian stable-jessie main" | tee /etc/apt/sources.list.d/mono-official-stable.list
apt-get update
apt-get -y install mono-devel mono-complete mono-dbg referenceassemblies-pcl mono-xsp4 ca-certificates-mono

sudo debconf-set-selections <<< 'mariadb-server mariadb-server/root_password password $DBPASS'
sudo debconf-set-selections <<< 'mariadb-server mariadb-server/root_password_again password $DBPASS'
apt-get -y install mariadb-server

cat >> createdatabase <<EOF
CREATE DATABASE $DBNAME;
GRANT ALL PRIVILEGES ON $DBNAME.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL ON $DBNAME.* TO 'root'@'localhost' WITH GRANT OPTION;
EOF

mysql -u root -p $DBPASS < createdatabase













#
# sed -i "s|127.0.0.1:3001|127.0.0.1:80|g" settings.json
# sed -i "s|3001|80|g" settings.json
# sed -i "s|Darkcoin|Elicoin|g" settings.json
# sed -i "s|DRK|ELI|g" settings.json
# sed -i "s|1337|0|g" settings.json
# sed -i "s|1733320247b15ca2262be646397d1ffd6be953fa638ebb8f5dcbb4c2b91b34f1|$GENESIS_BLOCK|g" settings.json
# sed -i "s|f270cd3813254c9922a2e222a56ba745842d9112223a1394062e460b33d27b7e|$GENESIS_TX|g" settings.json
# sed -i "s|b2926a56ca64e0cd2430347e383f63ad7092f406088b9b86d6d68c2a34baef51|$GENESIS_BLOCK|g" settings.json
# sed -i "s|65f705d2f385dc85763a317b3ec000063003d6b039546af5d8195a5ec27ae410|$GENESIS_TX|g" settings.json
# sed -i "s|RBiXWscC63Jdn1GfDtRj8hgv4Q6Zppvpwb|$ADDRESS|g" settings.json
#
# sed -i "s|iquidus|$DBUSER|g" settings.json
# sed -i "s|3xp!0reR|$DBPASS|g" settings.json
# sed -i "s|explorerdb|$DBNAME|g" settings.json
#
# sed -i "s|darkcoinrpc|$RPCUSER|g" settings.json
# sed -i "s|123gfjk3R3pCCVjHtbRde2s5kzdf233sa|$RPCPASS|g" settings.json
# sed -i "s|9332|$RPCPORT|g" settings.json
