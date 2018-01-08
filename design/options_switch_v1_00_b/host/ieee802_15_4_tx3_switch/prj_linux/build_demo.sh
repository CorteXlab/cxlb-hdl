#!/bin/bash
#set -x
DIR="../bin"
#mkdir $DIR

if [ ! -d $DIR ];then
mkdir $DIR

fi

make -f Makefile

cp ../bin/TxRxSW ../../../host/bin/
