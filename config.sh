#!/bin/bash

#******************************************** SCRIPT SETTINGS ***************************************
# Ovverrides difficulty compute algorithm and always return lowest limit (Just for test purposes. Please do not set this parameter to TRUE if you do not know what are you doing.)
export ALWAYS_MINIMUM_DIFF="FALSE"
# Affects 00-install-dependencies.sh and 02-compilation.sh
# Whether building on debian->TRUE or on ubuntu->FALSE
export DEBIAN="FALSE"
# Affects 00-install-dependencies.sh 02-compilation.sh ... crosscompilation for windows always compile with gui
# Whether build with gui
export GUI="TRUE"
# Affects 01-code.sh
# Whether mine genesis blocks
export IF_GENESIS="TRUE"
# Affects 01-code.sh
# Whether generate genesis coinbase key stored in genesiscoinbase.pem, genesiscoinbase.hex
export IF_KEYS="TRUE"
#*****************************************************************************************************

#******************************* COIN SETTINGS *******************************************************
# Change stuff from about
export COIN_GITHUB="https://github.com/elicoin/elicoin"
export URL_WEBSITE="https://elicoin.net"
export FROM_YEAR="2017"
export TO_YEAR="2018"

export COIN_NAME="Mycoin"
export COIN_UNIT="MYC"
# Link to the version used in the script
export RELEASE_URL="https://github.com/litecoin-project/litecoin/archive/v0.14.2.tar.gz"
# Newspaper title of the day
export PHRASE="Bloomberg 24/Jan/2018 UBSChairmanSaysaMassiveBitcoinCorrectionIsPossible"
export MAINNET_PORT="9133"
export TESTNET_PORT="19135"
# https://www.epochconverter.com/
# Should be gradual (first mainnet, then testnet, then regtest)
export MAINNET_GENESIS_TIMESTAMP="1516814255"
export TEST_GENESIS_TIMESTAMP="1516831393"
export REGTEST_GENESIS_TIMESTAMP="1516835334"

# Genesis block difficulty
# Note NBITS is in short difficulty encoding
# https://bitcoin.stackexchange.com/questions/30467/what-are-the-equations-to-convert-between-bits-and-difficulty
# first two numbers * 2 = number of positions                (maximum 0x20 = 64 positions)
# last six numbers = difficulty prefix
# please do not set NBITS greater than MIN_DIFF
#
# example:
# 0x1d00ffff -> 0x00ffff0000000000000000000000000000000000000000000000000000
# 0x20000fff -> 0x000fff0000000000000000000000000000000000000000000000000000000000          (0x20 = 64 positions    and   000fff = prefix )
# 0x20000fff is blocktime under the minute on single i7 core with yescryptR16
export NBITS="0x20000fff"

# Minimum difficulty (but maximal threshold)
export MIN_DIFF="000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
# Block time
# "minutes * 60"
export POW_TARGET_SPACING="2.5 * 60"
# Genesis reward
# must be exactly this format "x * COIN"
export GENESIS_REWARD="10 * COIN"

# https://en.bitcoin.it/wiki/Controlled_supply
export HALVING_INTERVAL="840000"

# Maximal amount. Coin core use it just for check
# MAX_MONEY
# No amount larger than this (in satoshi) is valid.
# Note that this constant is *not* the total money supply, which in Bitcoin
# currently happens to be less than 21,000,000 BTC for various reasons, but
# rather a sanity check. As this sanity check is used by consensus-critical
# validation code, the exact value of the MAX_MONEY constant is consensus
# critical; in unusual circumstances like a(nother) overflow bug that allowed
# for the creation of coins out of thin air modification could lead to a fork.
#
# Recommended to set as half of the whole coin supply
export MAX_MONEY="42000000"

# How much blocks before coinbase (mined) transaction could be spent
export COINBASE_MATURITY="100"

# Block size in MB (without SegWit...). With SegWit approximately 4*MAX_BLOCK_BASE_SIZE
# https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki
export MAX_BLOCK_BASE_SIZE_MB="1"

# Mainnet estimated transactions per second
export MAINNET_ESTIMATED_TRANSACTIONS="0.01"
# Testnet estimated transactions per second
export TEST_ESTIMATED_TRANSACTIONS="0.001"


# http://dillingers.com/blog/2015/04/18/how-to-make-an-altcoin/  search for  'The Key Prefixes'
# https://en.bitcoin.it/wiki/List_of_address_prefixes  Table of values
# base58Prefixes[PUBKEY_ADDRESS], base58Prefixes[SCRIPT_ADDRESS], base58Prefixes[SCRIPT_ADDRESS2], base58Prefixes[SECRET_KEY]
export base58Prefixes_PUBKEY_ADDRESS_MAIN="48"
export base58Prefixes_SCRIPT_ADDRESS_MAIN="5"
export base58Prefixes_SCRIPT_ADDRESS2_MAIN="50"
export base58Prefixes_SECRET_KEY_MAIN="176"

export base58Prefixes_PUBKEY_ADDRESS_TEST="111"
export base58Prefixes_SCRIPT_ADDRESS_TEST="196"
export base58Prefixes_SCRIPT_ADDRESS2_TEST="58"
export base58Prefixes_SECRET_KEY_TEST="239"



# BIP32 extended key prefixes
# there are certain rules first two positions must be the same within the net (mainnet/testnet), the last last two positions must differ within the net
# PUBLIC_PREFIX represents base58Prefixes[EXT_PUBLIC_KEY], PRIVATE_PREFIX represents base58Prefixes[EXT_SECRET_KEY]
# http://dillingers.com/blog/2015/04/18/how-to-make-an-altcoin/  also search for  'The Key Prefixes'
# https://bitcoin.stackexchange.com/questions/28380/i-want-to-generate-a-bip32-version-number-for-namecoin-and-other-altcoins
# Valid values are: 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz
# !!!  0 (zero), O (Capital o), l (lower case L), I (capital i) are ommited!!!!

# EXT_SECRET_KEY, EXT_PUBLIC_KEY # Network                 : Prefixes
# ----------------------------------------------------------------------
# 0x0488ADE4,     0x0488B21E     # BTC  Bitcoin    mainnet : xprv / xpub
# 0x04358394,     0x043587CF     # BTC  Bitcoin    testnet : tprv / tpub
# 0x019D9CFE,     0x019DA462     # LTC  Litecoin   mainnet : Ltpv / Ltub
# 0x0436EF7D,     0x0436F6E1     # LTC  Litecoin   testnet : ttpv / ttub
# 0x02FE52F8,     0x02FE52CC     # DRK  Darkcoin   mainnet : drkv / drkp
# 0x3A8061A0,     0x3A805837     # DRK  Darkcoin   testnet : DRKV / DRKP
# 0x0488ADE4,     0x0488B21E     # VIA  Viacoin    mainnet : xprv / xpub
# 0x04358394,     0x043587CF     # VIA  Viacoin    testnet : tprv / tpub
# 0x02FD3955,     0x02FD3929     # DOGE Dogecoin   mainnet : dogv / dogp
# 0x0488ADE4,     0x0488B21E     # VTC  Vertcoin   mainnet : vtcv / vtcp
# 0x02CFBF60,     0x02CFBEDE     # BC   Blackcoin  mainnet : bcpv / bcpb
# 0x03A04DB7,     0x03A04D8B     # MEC  Megacoin   mainnet : mecv / mecp
# 0x0488ADE4,     0x0488B21E     # MYR  Myriadcoin mainnet : myrv / myrp
# 0x0488ADE4,     0x0488B21E     # UNO  Unobtanium mainnet : unov / unop
# 0x037A6460,     0x037A689A     # JBS  Jumbucks   mainnet : jprv / jpub
# 0x0488ADE4,     0x0488B21E     # MZC  Mazacoin   mainnet : xprv / xpub

export PUBLIC_PREFIX_MAIN="ecpb"
export PRIVATE_PREFIX_MAIN="ecrv"
export PUBLIC_PREFIX_TEST="tepb"
export PRIVATE_PREFIX_TEST="terv"
# **************************************************************************************************
