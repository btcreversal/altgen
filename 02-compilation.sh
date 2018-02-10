#!/bin/bash

exec bash
source config.sh

COIN_NAME_LOWER=${COIN_NAME,,}
COIN_NAME_UPPER=${COIN_NAME^^}




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
make -j 6


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
