#!/bin/bash

source config.sh
source ~/.bashrc

COIN_NAME_LOWER=${COIN_NAME,,}
COIN_NAME_UPPER=${COIN_NAME^^}



installdb_debian() {
  wget https://raw.githubusercontent.com/bitcoin/bitcoin/master/contrib/install_db4.sh
  chmod u+x install_db4.sh
  ./install_db4.sh `pwd`
  export BDB_PREFIX=`pwd`'/db4'
  echo "export BDB_PREFIX='${BDB_PREFIX}'" >> ~/.bashrc
  # ./configure LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"
}

installdb_ubuntu() {
  sudo apt-get -y install software-properties-common
  sudo add-apt-repository -y ppa:bitcoin/bitcoin
  sudo apt-get -y update
  sudo apt-get -y install libdb4.8-dev libdb4.8++-dev
}


install_dependencies() {
  apt-get -y install sudo
  sudo apt-get -y install automake pkg-config libevent-dev bsdmainutils
  sudo apt-get -y install git
  sudo apt-get -y install build-essential
  sudo apt-get -y install libtool autotools-dev autoconf
  sudo apt-get -y install libssl-dev
  sudo apt-get -y install libboost-all-dev
  sudo apt-get -y install pkg-config
  #download_code
  if [ $GUI == "TRUE" ]
  then
    sudo apt-get -y install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
    sudo apt-get -y install libqrencode-dev
  else
    echo " "
  fi
  if [ $DEBIAN == "TRUE" ]
  then
    mkdir ~/database
    cd ~/database/
    installdb_debian
  else
    installdb_ubuntu
  fi

}



build(){
#build sources for linux
./autogen.sh
if [ $DEBIAN == "TRUE" ]
then
  if [ $GUI == "TRUE" ]
  then
    ./configure --disable-tests --disable-gui-tests --disable-bench LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"
  else
    ./configure --without-gui --disable-tests --disable-gui-tests --disable-bench LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"
  fi
else
  if [ $GUI == "TRUE" ]
  then
    ./configure --disable-tests --disable-gui-tests --disable-bench
  else
    ./configure --disable-tests --disable-gui-tests --disable-bench --without-gui
  fi
fi
export NUMCPUS=`grep -c '^processor' /proc/cpuinfo`
make


if [ $IF_GENESIS == "TRUE" ]
then
  echo " "
  echo "Mining genesis blocks now... this may take a while ... you can go and have some coffee or maybe a lunch :)"
  src/${COIN_NAME_LOWER}d
  echo "Genesis blocks mined"
  IF_GENESIS="FALSE"
  INSTALL_DEPENDENCIES="FALSE"
else
  mkdir ../unixinstall
  make install DESTDIR=`pwd`/../unixinstall
fi
}

if [ $IF_GENESIS == "TRUE" ]
then
  cd ${COIN_NAME_LOWER}
  build
  cd ..
  ./01-code.sh -nogenesis
  IF_GENESIS="FALSE"
  INSTALL_DEPENDENCIES="FALSE"
  IF_KEYS="FALSE"
  cd ${COIN_NAME_LOWER}
  build
else
  cd ${COIN_NAME_LOWER}
  build
fi
