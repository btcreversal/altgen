#!/bin/bash


# ******************************* Coin settings *******************************************
COIN_NAME="Mycoin"
rm -rf $COIN_NAME
COIN_UNIT="MYC"
RELEASE_URL="https://github.com/litecoin-project/litecoin/archive/v0.14.2.tar.gz"
PHRASE="Bloomberg 24/Jan/2018 UBSChairmanSaysaMassiveBitcoinCorrectionIsPossible"
MAINNET_PORT="9133"
TESTNET_PORT="19135"
MAINNET_GENESIS_TIMESTAMP="1516814253"
TEST_GENESIS_TIMESTAMP="1516831393"
REGTEST_GENESIS_TIMESTAMP="1516835334"
MAIN_NONCE=`cat mainnonce.txt`
TEST_NONCE=`cat testnonce.txt`
REGTEST_NONCE=`cat regtestnonce.txt`
BITS="0x1e0ffff0"
POW_TARGET_SPACING="2.5 * 60"
# must be "x * COIN"
GENESIS_REWARD="50 * COIN"
HALVING_INTERVAL="840000"
#mainnet estimated transactions per second
MAINNET_ESTIMATED_TRANSACTIONS="0.01"
TEST_ESTIMATED_TRANSACTIONS="0.001"

# nVersion ? last is 4?
MAIN_GENESIS_HASH=`cat maingenesis.txt`
MAIN_MERKLE_HASH=`cat mainmerkle.txt`
TEST_GENESIS_HASH=`cat testgenesis.txt`
TEST_MERKLE_HASH=`cat testmerkle.txt`
REGTEST_GENESIS_HASH=`cat regtestgenesis.txt`
REGTEST_MERKLE_HASH=`cat regtestmerkle.txt`

#Message start strings (magic bytes)
# The message start string is designed to be unlikely to occur in normal data.
# The characters are rarely used upper ASCII, not valid as UTF-8, and produce
# a large 32-bit integer with any alignment.
#MAINNET
MAIN_MESSAGE_S_0="0xfb"
MAIN_MESSAGE_S_1="0xf9"
MAIN_MESSAGE_S_2="0xb6"
MAIN_MESSAGE_S_3="0xbe"
#TESTNET
TEST_MESSAGE_S_0="0xfd"
TEST_MESSAGE_S_1="0xd2"
TEST_MESSAGE_S_2="0xd9"
TEST_MESSAGE_S_3="0xf1"
#REGTEST
REGTEST_MESSAGE_S_0="0xfa"
REGTEST_MESSAGE_S_1="0xbf"
REGTEST_MESSAGE_S_2="0xb4"
REGTEST_MESSAGE_S_3="0xd8"

# key string prefixes mainnet
# there are certain rules firs must be the same through all nets, second must be the same within the net, last two must differ
MAIN_PREFIX_PUBLIC="(0x09)(0x44)(0xA2)(0x2E)"
MAIN_PREFIX_SECRET="(0x09)(0x44)(0xA1)(0xE2)"

#key string prefixes testnet
TEST_PREFIX_PUBLIC="(0x09)(0x33)(0x87)(0xCF)"
TEST_PREFIX_SECRET="(0x09)(0x33)(0x83)(0x94)"
# **************************************************************************************************







# ******************************************** OTHER SETTINGS ***************************************
# ovverrides difficulty compute algorithm and always return lowest limit
ALWAYS_MINIMUM_DIFF="TRUE"
# whether building on debian or on ubuntu
DEBIAN="TRUE"
# whether install dependencies or they are already installed
INSTALL_DEPENDENCIES="FALSE"
# whether build with gui
GUI="FALSE"
#whether
IF_BUILD="TRUE"
#whether instal core client
IF_INSTALL="TURE"
#whether mine genesis blocks
IF_GENESIS="FALSE"

#*****************************************************************************************************
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
  sudo apt-get install software-properties-common
  sudo add-apt-repository ppa:bitcoin/bitcoin
  sudo apt-get update
  sudo apt-get install libdb4.8-dev libdb4.8++-dev
}


install_dependencies() {
  apt-get -y install sudo
  sudo apt-get -y install git
  sudo apt-get -y install build-essential
  sudo apt-get -y install libtool autotools-dev autoconf
  sudo apt-get -y install libssl-dev
  sudo apt-get -y install libboost-all-dev
  sudo apt-get -y install pkg-config
  #download_code
  if [ $GUI == "TRUE" ]
  then
    sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
    sudo apt-get install libqrencode-dev
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







# download and unpack litecoin sources into new coin folder
wget ${RELEASE_URL} -O ${COIN_NAME}.tar.gz
mkdir ${COIN_NAME}
tar -xf ${COIN_NAME}.tar.gz -C ./${COIN_NAME} --strip-components 1
rm ${COIN_NAME}.tar.gz

# copy yescryptR16 files into new coin source folder
cp -r hash ${COIN_NAME}/src/

# pushd $COIN_NAME
cd ${COIN_NAME}


if [ -d $COIN_NAME_LOWER ]; then
    echo "Warning: $COIN_NAME_LOWER already existing"
    return 0
fi
# clone litecoin


# first rename all directories
for i in $(find . -type d | grep -v "^./.git" | grep litecoin); do
    mv $i $(echo $i| sed "s/litecoin/$COIN_NAME_LOWER/")
done

# then rename all files
for i in $(find . -type f | grep -v "^./.git" | grep litecoin); do
    mv $i $(echo $i| sed "s/litecoin/$COIN_NAME_LOWER/")
done

# now replace all litecoin references to the new coin name
for i in $(find . -type f | grep -v "^./.git"); do
    sed -i "s/Litecoin/$COIN_NAME/g" $i
    sed -i "s/litecoin/$COIN_NAME_LOWER/g" $i
    sed -i "s/LITECOIN/$COIN_NAME_UPPER/g" $i
    sed -i "s/LTC/$COIN_UNIT/g" $i
done

# popd

# add yescryptR16 sources to autogen makefile
sed -i -e 's#consensus/validation.h[[:space:]]\\#consensus/validation.h \\\n  hash/yescrypt/yescrypt.h \\\n  hash/yescrypt/yescrypt.c \\\n  hash/yescrypt/sha256.h \\\n  hash/yescrypt/sha256_c.h \\\n  hash/yescrypt/yescrypt-best_c.h \\\n  hash/yescrypt/sysendian.h \\\n  hash/yescrypt/yescrypt-platform_c.h \\\n  hash/yescrypt/yescrypt-opt_c.h \\\n  hash/yescrypt/yescrypt-simd_c.h \\#g' src/Makefile.am
echo '' >> src/Makefile.am
echo 'if TARGET_DARWIN' >> src/Makefile.am
echo 'CFLAGS += -O3 -msse4.1 -funroll-loops -fomit-frame-pointer' >> src/Makefile.am
echo 'else' >> src/Makefile.am
echo 'CFLAGS += -msse4.1 -fPIC' >> src/Makefile.am
echo 'endif' >> src/Makefile.am

# deactivate chain control
sed -i -e 's#// Once this function has returned false, it must remain false.#return false;\n    // Once this function has returned false, it must remain false.#g' src/validation.cpp
sed -i -e 's#if[[:space:]](nHeight[[:space:]]>=[[:space:]]consensusParams.BIP34Height)#//if (nHeight >= consensusParams.BIP34Height)\n    if(false)#g' src/validation.cpp

#copy seeds file
cp ../chainparamsseeds.h src/

#change hash to yescrypt
sed -i -e 's+#include[[:space:]]"crypto/scrypt.h"+#include "crypto/scrypt.h"\n\nextern "C" void yescrypt_hash(const char *input, char *output);+g' src/primitives/block.cpp
sed -i -e 's+scrypt_1024_1_1_256+yescrypt_hash+g' src/primitives/block.cpp

#add mining code
if [ $IF_GENESIS == "TRUE" ]
then
  sed -i -e 's+#include[[:space:]]"chainparamsseeds.h"+#include "chainparamsseeds.h"\n#include "arith_uint256.h"\n#include <iostream>\n#include <fstream>\n\nbool CheckProofOfWorkCustom(uint256 hash, unsigned int nBits, const Consensus::Params\& params);\n\nbool mineMainnet = true;\nbool mineTestNet = true;\nbool mineRegtest = true;\n\nvoid mineGenesis(Consensus::Params\& consensus,CBlock\& genesis,std::string net="main");+g' src/chainparams.cpp
  sed -i -e 's+genesis[[:space:]]=[[:space:]]CreateGenesisBlock(1317972665,[[:space:]]2084524493,[[:space:]]0x1e0ffff0,[[:space:]]1,[[:space:]]50[[:space:]]\*[[:space:]]COIN);+genesis = CreateGenesisBlock(1317972665, 2084524493, 0x1e0ffff0, 1, 50 * COIN);\n        mineGenesis(consensus,genesis);+g' src/chainparams.cpp
  sed -i -e 's+genesis[[:space:]]=[[:space:]]CreateGenesisBlock(1486949366,[[:space:]]293345,[[:space:]]0x1e0ffff0,[[:space:]]1,[[:space:]]50[[:space:]]\*[[:space:]]COIN);+genesis = CreateGenesisBlock(1486949366, 293345, 0x1e0ffff0, 1, 50 * COIN);\n        mineGenesis(consensus,genesis,"test");+g' src/chainparams.cpp
  sed -i -e 's+genesis[[:space:]]=[[:space:]]CreateGenesisBlock(1296688602,[[:space:]]0,[[:space:]]0x207fffff,[[:space:]]1,[[:space:]]50[[:space:]]\*[[:space:]]COIN);+genesis = CreateGenesisBlock(1296688602, 0, 0x207fffff, 1, 50 * COIN);\n        mineGenesis(consensus,genesis,"regtest");\n        assert(false);+g' src/chainparams.cpp

  echo 'bool CheckProofOfWorkCustom(uint256 hash, unsigned int nBits, const Consensus::Params& params)' >> src/chainparams.cpp
  echo '{' >> src/chainparams.cpp
  echo '    bool fNegative;' >> src/chainparams.cpp
  echo '    bool fOverflow;' >> src/chainparams.cpp
  echo '    arith_uint256 bnTarget;' >> src/chainparams.cpp
  echo '' >> src/chainparams.cpp
  echo '    bnTarget.SetCompact(nBits, &fNegative, &fOverflow);' >> src/chainparams.cpp
  echo '' >> src/chainparams.cpp
  echo '    // Check range' >> src/chainparams.cpp
  echo '    if (fNegative || bnTarget == 0 || fOverflow || bnTarget > UintToArith256(params.powLimit))' >> src/chainparams.cpp
  echo '        return false;' >> src/chainparams.cpp
  echo '' >> src/chainparams.cpp
  echo '    // Check proof of work matches claimed amoun' >> src/chainparams.cpp
  echo '    if (UintToArith256(hash) > bnTarget)' >> src/chainparams.cpp
  echo '        return false;' >> src/chainparams.cpp
  echo '' >> src/chainparams.cpp
  echo '    return true;' >> src/chainparams.cpp
  echo '}' >> src/chainparams.cpp
  echo '' >> src/chainparams.cpp
  echo '' >> src/chainparams.cpp

  echo 'void mineGenesis(Consensus::Params& consensus,CBlock& genesis,std::string net)' >> src/chainparams.cpp
  echo '{' >> src/chainparams.cpp
  echo '    consensus.hashGenesisBlock = uint256S("0x01");' >> src/chainparams.cpp
  echo '    int counter = 0;' >> src/chainparams.cpp
  echo '    while(!CheckProofOfWorkCustom(genesis.GetPoWHash(), genesis.nBits, consensus)){' >> src/chainparams.cpp
  echo '        if(genesis.nNonce % 1000000 == 0){' >> src/chainparams.cpp
  echo '          std::cout << ++counter <<  "Mh " << std::flush ;' >> src/chainparams.cpp
  echo '        }' >> src/chainparams.cpp
  echo '        ++genesis.nNonce;' >> src/chainparams.cpp
  echo '    }' >> src/chainparams.cpp
  echo '    std::ofstream ofile;' >> src/chainparams.cpp
  echo '    ofile.open("../"+net+"genesis.txt");' >> src/chainparams.cpp
  echo '    ofile << "0x" << genesis.GetHash().ToString();' >> src/chainparams.cpp
  echo '    ofile.close();' >> src/chainparams.cpp
  echo '    ofile.open("../"+net+"merkle.txt");' >> src/chainparams.cpp
  echo '    ofile << "0x" << genesis.hashMerkleRoot.ToString();' >> src/chainparams.cpp
  echo '    ofile.close();' >> src/chainparams.cpp
  echo '    ofile.open("../"+net+"nonce.txt");' >> src/chainparams.cpp
  echo '    ofile << genesis.nNonce;' >> src/chainparams.cpp
  echo '    ofile.close();' >> src/chainparams.cpp
  echo '}' >> src/chainparams.cpp
  echo '' >> src/chainparams.cpp
  echo '' >> src/chainparams.cpp

else
  echo " "
fi

# add DarkGravityWave v3 support
sed -i -e 's+#include[[:space:]]"util.h"+#include "util.h"\n\nunsigned int static DarkGravityWave(const CBlockIndex* pindexLast, const Consensus::Params\& params);+g' src/pow.cpp
sed -i -e 's+unsigned[[:space:]]int[[:space:]]nProofOfWorkLimit[[:space:]]=[[:space:]]UintToArith256(params.powLimit).GetCompact();+return DarkGravityWave(pindexLast,params);\n    unsigned int nProofOfWorkLimit = UintToArith256(params.powLimit).GetCompact();+g' src/pow.cpp

echo 'unsigned int static DarkGravityWave(const CBlockIndex* pindexLast, const Consensus::Params& params) {' >> src/pow.cpp
echo '    /* current difficulty formula, dash - DarkGravity v3, written by Evan Duffield - evan@dash.org */' >> src/pow.cpp
echo '    const arith_uint256 bnPowLimit = UintToArith256(params.powLimit);' >> src/pow.cpp
echo '    int64_t nPastBlocks = 24;' >> src/pow.cpp
echo '    // make sure we have at least (nPastBlocks + 1) blocks, otherwise just return powLimit' >> src/pow.cpp
echo '    if (!pindexLast || pindexLast->nHeight < nPastBlocks) {' >> src/pow.cpp
echo '        return bnPowLimit.GetCompact();' >> src/pow.cpp
echo '    }' >> src/pow.cpp
echo '    const CBlockIndex *pindex = pindexLast;' >> src/pow.cpp
echo '    arith_uint256 bnPastTargetAvg;' >> src/pow.cpp
echo '    for (unsigned int nCountBlocks = 1; nCountBlocks <= nPastBlocks; nCountBlocks++) {' >> src/pow.cpp
echo '        arith_uint256 bnTarget = arith_uint256().SetCompact(pindex->nBits);' >> src/pow.cpp
echo '        if (nCountBlocks == 1) {' >> src/pow.cpp
echo '            bnPastTargetAvg = bnTarget;' >> src/pow.cpp
echo '        } else {' >> src/pow.cpp
echo '            // NOTE: thats not an average really...' >> src/pow.cpp
echo '            bnPastTargetAvg = (bnPastTargetAvg * nCountBlocks + bnTarget) / (nCountBlocks + 1);' >> src/pow.cpp
echo '        }' >> src/pow.cpp
echo '' >> src/pow.cpp
echo '        if(nCountBlocks != nPastBlocks) {' >> src/pow.cpp
echo '            assert(pindex->pprev); // should never fail' >> src/pow.cpp
echo '            pindex = pindex->pprev;' >> src/pow.cpp
echo '        }' >> src/pow.cpp
echo '    }' >> src/pow.cpp
echo '' >> src/pow.cpp
echo '    arith_uint256 bnNew(bnPastTargetAvg);' >> src/pow.cpp
echo '    int64_t nActualTimespan = pindexLast->GetBlockTime() - pindex->GetBlockTime();' >> src/pow.cpp
echo '    // NOTE: is this accurate? nActualTimespan counts it for (nPastBlocks - 1) blocks only...' >> src/pow.cpp
echo '' >> src/pow.cpp
echo '    int64_t nTargetTimespan = nPastBlocks * params.nPowTargetSpacing;' >> src/pow.cpp
echo '' >> src/pow.cpp
echo '    if (nActualTimespan < nTargetTimespan/3)' >> src/pow.cpp
echo '        nActualTimespan = nTargetTimespan/3;' >> src/pow.cpp
echo '    if (nActualTimespan > nTargetTimespan*3)' >> src/pow.cpp
echo '        nActualTimespan = nTargetTimespan*3;' >> src/pow.cpp
echo '' >> src/pow.cpp
echo '    // Retarget' >> src/pow.cpp
echo '    bnNew *= nActualTimespan;' >> src/pow.cpp
echo '    bnNew /= nTargetTimespan;' >> src/pow.cpp
echo '    if (bnNew > bnPowLimit) {' >> src/pow.cpp
echo '        bnNew = bnPowLimit;' >> src/pow.cpp
echo '' >> src/pow.cpp
echo '    }' >> src/pow.cpp
echo '    return bnNew.GetCompact();' >> src/pow.cpp
echo '}' >> src/pow.cpp
echo '' >> src/pow.cpp
echo '' >> src/pow.cpp


sed -i "s;NY Times 05/Oct/2011 Steve Jobs, Apple’s Visionary, Dies at 56;$PHRASE;" src/chainparams.cpp
# sed -i -e 's+NY[[:space:]]Times[[:space:]]05/Oct/2011[[:space:]]Steve Jobs,[[:space:]]Apple’s[[:space:]]Visionary,[[:space:]]Dies[[:space:]]at[[:space:]]56+Bloomberg 24/Jan/2018 UBSChairmanSaysaMassiveBitcoinCorrectionIsPossible+g' src/chainparams.cpp
sed -i -e 's+consensus.BIP34Height[[:space:]]=[[:space:]]710000;+consensus.BIP34Height = 0;+g' src/chainparams.cpp
sed -i -e 's:fa09d204a83a768ed5a7c8d441fa62f2043abf420cff1226c7b4329aeb9d51cf:0x00:g' src/chainparams.cpp
sed -i -e 's+consensus.BIP65Height[[:space:]]=[[:space:]]918684;+consensus.BIP65Height = 0;+g' src/chainparams.cpp
sed -i -e 's+consensus.BIP66Height[[:space:]]=[[:space:]]811879;+consensus.BIP66Height = 0;+g' src/chainparams.cpp
sed -i -e 's+vSeeds.emplace_back+//vSeeds.emplace_back+g' src/chainparams.cpp

sed -i "s/= 9333;/= $MAINNET_PORT;/" src/chainparams.cpp
sed -i "s/= 19335;/= $TESTNET_PORT;/" src/chainparams.cpp

sed -i "0,/2084524493/s//$MAIN_NONCE/" src/chainparams.cpp
sed -i "0,/293345/s//$TEST_NONCE/" src/chainparams.cpp
sed -i "0,/1296688602, 0/s//1296688602, $REGTEST_NONCE/" src/chainparams.cpp

sed -i "s/1317972665/$MAINNET_GENESIS_TIMESTAMP/" src/chainparams.cpp
sed -i "s/1486949366/$TEST_GENESIS_TIMESTAMP/" src/chainparams.cpp
sed -i "s/1296688602/$REGTEST_GENESIS_TIMESTAMP/" src/chainparams.cpp



sed -i "0,/0x1e0ffff0/s//$BITS/" src/chainparams.cpp
sed -i "s/50 * COIN/$GENESIS_REWARD/" src/chainparams.cpp
sed -i "s/2.5 * 60/$POW_TARGET_SPACING/" src/chainparams.cpp
sed -i "s/840000/$HALVING_INTERVAL/" src/chainparams.cpp


# change minimum chain work (whole chain)
#mainnet
sed -i "s/0x0000000000000000000000000000000000000000000000000000364b0cbc3568/0x00/" src/chainparams.cpp
#testnet
sed -i "s/0x000000000000000000000000000000000000000000000000000000054cb9e7a0/0x00/" src/chainparams.cpp

#Genesis hash mainnet
# default assume valid
sed -i "s/0x12a765e31ffd4059bada1e25190f6e98c99d9714d334efa41a195a7e7e04bfe2/$MAIN_GENESIS_HASH/" src/chainparams.cpp
#asserts
sed -i "s/0x29c8c00e1a5f446a6364a29633d3f1ee16428d87c8d3851a1c570be8170b04c2/$MAIN_GENESIS_HASH/" src/chainparams.cpp
sed -i "s/0x97ddfbbae6be97fd6cdf3e7ca13232a3afff2353e29badfab7f73011edd4ced9/$MAIN_MERKLE_HASH/" src/chainparams.cpp


#Genesis hash testnet
# default assume valid
sed -i "s/0xad8ff6c2f5580d2b50bd881e11312425ea84fa99f322bf132beb722f97971bba/$TEST_GENESIS_HASH/" src/chainparams.cpp
#asserts
sed -i "s/0x4966625a4b2851d9fdee139e56211a0d88575f59ed816ff5e6a63deb4e3e29a0/$TEST_GENESIS_HASH/" src/chainparams.cpp
sed -i "s/0x97ddfbbae6be97fd6cdf3e7ca13232a3afff2353e29badfab7f73011edd4ced9/$TEST_MERKLE_HASH/" src/chainparams.cpp


#Genesis hash regtest
#asserts
sed -i "s/0x530827f38f93b43ed12af0b3ad25a288dc02ed74d6d7857862df51fc56c416f9/$REGTEST_GENESIS_HASH/" src/chainparams.cpp
sed -i "s/0x97ddfbbae6be97fd6cdf3e7ca13232a3afff2353e29badfab7f73011edd4ced9/$REGTEST_MERKLE_HASH/" src/chainparams.cpp

#ChainTxData
#testnet
#Total number of transaction between genesis and last known timestamp
sed -i "s/8731/0/" src/chainparams.cpp
sed -i "s/1487715270/$TEST_GENESIS_TIMESTAMP/" src/chainparams.cpp
sed -i "s/0\.01/$TEST_ESTIMATED_TRANSACTIONS/" src/chainparams.cpp
#mainnet
#Total number of transaction between genesis and last known timestamp
sed -i "s/9243806/0/" src/chainparams.cpp
sed -i "s/1487715936/$MAINNET_GENESIS_TIMESTAMP/" src/chainparams.cpp
sed -i "s/0\.06/$MAINNET_ESTIMATED_TRANSACTIONS/" src/chainparams.cpp

#comment checkpoints
#mainnet
sed -i "s|(  1500, uint256S|(  0, uint256S|g" src/chainparams.cpp
sed -i "s|0x841a2965955dd288cfa707a755d05a54e45f8bd476835ec9af4402a2b59a2967|$MAIN_GENESIS_HASH|g" src/chainparams.cpp
sed -i "s|(  4032, uint256S|//(  4032, uint256S|g" src/chainparams.cpp
sed -i "s|(  8064, uint256S|//(  8064, uint256S|g" src/chainparams.cpp
sed -i "s|( 16128, uint256S|//( 16128, uint256S|g" src/chainparams.cpp
sed -i "s|( 23420, uint256S|//( 23420, uint256S|g" src/chainparams.cpp
sed -i "s|( 50000, uint256S|//( 50000, uint256S|g" src/chainparams.cpp
sed -i "s|( 80000, uint256S|//( 80000, uint256S|g" src/chainparams.cpp
sed -i "s|(120000, uint256S|//(120000, uint256S|g" src/chainparams.cpp
sed -i "s|(161500, uint256S|//(161500, uint256S|g" src/chainparams.cpp
sed -i "s|(179620, uint256S|//(179620, uint256S|g" src/chainparams.cpp
sed -i "s|(240000, uint256S|//(240000, uint256S|g" src/chainparams.cpp
sed -i "s|(383640, uint256S|//(383640, uint256S|g" src/chainparams.cpp
sed -i "s|(409004, uint256S|//(409004, uint256S|g" src/chainparams.cpp
sed -i "s|(456000, uint256S|//(456000, uint256S|g" src/chainparams.cpp
sed -i "s|(638902, uint256S|//(638902, uint256S|g" src/chainparams.cpp
sed -i "s|(721000, uint256S|//(721000, uint256S|g" src/chainparams.cpp
#testnet
sed -i "s|(2056, uint256S|(0, uint256S|g" src/chainparams.cpp
sed -i "s|17748a31ba97afdc9a4f86837a39d287e3e7c7290a08a1d816c5969c78a83289|$TEST_GENESIS_HASH|g" src/chainparams.cpp
#regtest
sed -i "s|530827f38f93b43ed12af0b3ad25a288dc02ed74d6d7857862df51fc56c416f9|$REGTEST_GENESIS_HASH|g" src/chainparams.cpp
# sed -i "s||//|g" src/chainparams.cpp





#mainnet
sed -i "s|pchMessageStart\[0\] = 0xfb|pchMessageStart[0]  = $MAIN_MESSAGE_S_0|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[1\] = 0xc0|pchMessageStart[1]  = $MAIN_MESSAGE_S_1|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[2\] = 0xb6|pchMessageStart[2]  = $MAIN_MESSAGE_S_2|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[3\] = 0xdb|pchMessageStart[3]  = $MAIN_MESSAGE_S_3|g" src/chainparams.cpp
sed -i "s|(0x04)(0x88)(0xB2)(0x1E)|$MAIN_PREFIX_PUBLIC|g" src/chainparams.cpp
sed -i "s|(0x04)(0x88)(0xAD)(0xE4)|$MAIN_PREFIX_SECRET|g" src/chainparams.cpp

#Testnet
sed -i "s|pchMessageStart\[0\] = 0xfd|pchMessageStart[0]  = $TEST_MESSAGE_S_0|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[1\] = 0xd2|pchMessageStart[1]  = $TEST_MESSAGE_S_1|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[2\] = 0xc8|pchMessageStart[2]  = $TEST_MESSAGE_S_2|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[3\] = 0xf1|pchMessageStart[3]  = $TEST_MESSAGE_S_3|g" src/chainparams.cpp
#testnet and regtest are the same
sed -i "s|(0x04)(0x35)(0x87)(0xCF)|$TEST_PREFIX_PUBLIC|g" src/chainparams.cpp
sed -i "s|(0x04)(0x35)(0x83)(0x94)|$TEST_PREFIX_SECRET|g" src/chainparams.cpp

#Regtest
sed -i "s|pchMessageStart\[0\] = 0xfa|pchMessageStart[0]  = $REGTEST_MESSAGE_S_0|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[1\] = 0xbf|pchMessageStart[1]  = $REGTEST_MESSAGE_S_1|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[2\] = 0xb5|pchMessageStart[2]  = $REGTEST_MESSAGE_S_2|g" src/chainparams.cpp
sed -i "s|pchMessageStart\[3\] = 0xda|pchMessageStart[3]  = $REGTEST_MESSAGE_S_3|g" src/chainparams.cpp




# ovverrides difficulty compute algorithm and always return lowest limit
if [ $ALWAYS_MINIMUM_DIFF == "TRUE" ]
then
  sed -i "s|00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff|000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff|g" src/chainparams.cpp
  sed -i "s|unsigned int nProofOfWorkLimit = UintToArith256(params.powLimit).GetCompact();|unsigned int nProofOfWorkLimit = UintToArith256(params.powLimit).GetCompact();\n    return nProofOfWorkLimit;|g" src/pow.cpp
else
  echo " "
fi

if [ $INSTALL_DEPENDENCIES == "TRUE" ]
then
  install_dependencies
else
  echo " "
fi



if [ $IF_BUILD == "TRUE" ]
then
  #build sources for linux
  ./autogen.sh
  if [ $DEBIAN == "TRUE" ]
  then
    if [ $GUI == "TRUE" ]
    then
      ./configure --disable-tests LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"
    else
      ./configure --without-gui --disable-tests LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"
    fi
  else
    if [ $GUI == "TRUE" ]
    then
      ./configure --disable-tests
    else
      ./configure --disable-tests --without-gui
    fi
  fi
  export NUMCPUS=`grep -c '^processor' /proc/cpuinfo`
  make
else
  echo " "
fi


if [ $IF_INSTALL == "TRUE" ]
then
  sudo make install
else
  echo " "
fi

src/mycoind
