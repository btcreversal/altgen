#!/bin/bash

DBUSER="dbuser"
DBPASS="dbpass"
DBNAME="coiniumdb"

RPCUSER="GERyFX9Fu3IPiE7a"
RPCPASS="2LMNh4PKq2aVT39NdtwGDIQr9QCC4cJOnCzfVbEthwc3FLn6TSYqhT4jpbRbKMpU"
RPCPORT="9999"


# find out what the magic bytes are
sleep 5
MAINMAGIC=`head -c 4 ~/.elicoin/blocks/blk00000.dat |hexdump -e '16/1 "%02x" "\n"'`
elicoin-cli stop
elicoind -daemon -testnet
sleep 10
TESTMAGIC=`head -c 4 ~/.elicoin/testnet4/blocks/blk00000.dat |hexdump -e '16/1 "%02x" "\n"'`
elicoin-cli stop
elicoind -daemon
sleep 5

# install mono framework (needed to build and run C#)
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian stable-jessie main" | tee /etc/apt/sources.list.d/mono-official-stable.list
apt-get update
apt-get -y install mono-devel mono-complete mono-dbg referenceassemblies-pcl mono-xsp4 ca-certificates-mono

# install database with pre-set password
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password $DBPASS"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $DBPASS"
apt-get -y install mariadb-server

# create database initializotion script
cat >> createdatabase <<EOF
CREATE DATABASE $DBNAME;
GRANT ALL PRIVILEGES ON $DBNAME.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL ON $DBNAME.* TO 'root'@'localhost' WITH GRANT OPTION;
EOF

# initialize database with script
mysql -u root -p'$DBPASS' < createdatabase

# install redis
cd ~
apt-get -y install build-essential
apt-get -y install tcl8.5
wget http://download.redis.io/releases/redis-stable.tar.gz
tar xzf redis-stable.tar.gz
cd redis-stable
make
make install
cd utils
./install_server.sh
service redis_6379 start
update-rc.d redis_6379 defaults

# build coinium
cd ~
apt-get -y install git
apt-get -y install nuget
git clone https://niedoluk@bitbucket.org/niedoluk/coiniumservyescrypt.git
cd coiniumservyescrypt/
nuget restore
xbuild CoiniumServ.sln /p:Configuration="Release"
cp src/CoiniumServ/Algorithms/Implementations/libyescrypt.so build/bin/Release








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
