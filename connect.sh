#!/bin/bash
#set -x
#=====================VARIABLES=======================
#CURRENT_DIR=$(pwd)
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files/connect.py"
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'

#===============Checking file =========================

#======================================================

usage(){

echo $WHITE "$(/bin/basename $0) :USAGE"
echo $YELLOW	       "$0 -i | --input_inst [name], -ip | --input_ports  [name]";
echo "	            -op |, --output_ports [name] ";
	exit

}
run(){
	${PATH} $@

}
if [[ $# -eq 1 && $1 = -h || $1 = --help ]]
then
	echo $GREEN " --help";
	usage
	exit 0

elif [[ $# -eq 1  ]]
then
	echo $RED "Error:Entered wrong argumment!"
	usage
	exit 1
else
	run $@
fi
#========================================================
