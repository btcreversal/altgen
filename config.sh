#!/bin/bash
# You can generate the chainparamsseeds.h with script placed in coin folder /contrib/seeds/generate-seeds.py

#******************************************** SCRIPT SETTINGS ***************************************
# ovverrides difficulty compute algorithm and always return lowest limit
export ALWAYS_MINIMUM_DIFF="FALSE"
# whether building on debian->TRUE or on ubuntu->FALSE
export DEBIAN="FALSE"
# whether build with gui
export GUI="FALSE"
#whether mine genesis blocks. note: when TRUE also the IF_BUILD must be TRUE
export IF_GENESIS="TRUE"
# whether generate genesis coinbase key
# stored in genesiscoinbase.pem, genesiscoinbase.hex
export IF_KEYS="FALSE"
#*****************************************************************************************************

#******************************* COIN SETTINGS *******************************************************
export COIN_NAME="Mycoin"
export COIN_UNIT="MYC"
export RELEASE_URL="https://github.com/litecoin-project/litecoin/archive/v0.14.2.tar.gz"
export PHRASE="Bloomberg 24/Jan/2018 UBSChairmanSaysaMassiveBitcoinCorrectionIsPossible"
export MAINNET_PORT="9133"
export TESTNET_PORT="19135"
export MAINNET_GENESIS_TIMESTAMP="1516814255"
export TEST_GENESIS_TIMESTAMP="1516831393"
export REGTEST_GENESIS_TIMESTAMP="1516835334"

# genesis block difficulty
# note NBITS is in short difficulty encoding
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

# minimum difficulty (but maximal threshold)
export MIN_DIFF="000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
# block time
# "minutes * 60"
export POW_TARGET_SPACING="2.5 * 60"
# genesis reward
# must be exactly this format "x * COIN"
export GENESIS_REWARD="50 * COIN"

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
export MAX_MONEY="42000001"

# mainnet estimated transactions per second
export MAINNET_ESTIMATED_TRANSACTIONS="0.01"
# testnet estimated transactions per second
export TEST_ESTIMATED_TRANSACTIONS="0.001"

# key string prefixes mainnet
# there are certain rules firs must be the same through all nets, second must be the same within the net, last two must differ
export MAIN_PREFIX_PUBLIC="(0x09)(0x44)(0xA2)(0x2E)"
export MAIN_PREFIX_SECRET="(0x09)(0x44)(0xA1)(0xE2)"

#key string prefixes testnet
export TEST_PREFIX_PUBLIC="(0x09)(0x33)(0x87)(0xCF)"
export TEST_PREFIX_SECRET="(0x09)(0x33)(0x83)(0x94)"
# **************************************************************************************************
