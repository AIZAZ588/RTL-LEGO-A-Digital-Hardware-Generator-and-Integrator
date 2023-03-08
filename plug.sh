#!/bin/bash
#set -x
#=====================VARIABLES=======================
#CURRENT_DIR=$(pwd)
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files/plug.py"
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'

#=====================================================

usage(){

echo $WHITE "$(/bin/basename $0) :USAGE"
echo $YELLOW	   "plug -f | --filename [name]  -n | --instance_name [name] ";

}

run(){
	${PATH} $@
	#/bin/cat 'last modified .sv file' --remaning

}
if [[ $# -eq 1 && $1 = -h || $1 = --help ]]
then
	echo $GREEN " --help";
	usage
	exit 0
else
	run $@
fi
