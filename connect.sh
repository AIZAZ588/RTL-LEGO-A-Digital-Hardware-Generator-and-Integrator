#!/bin/bash
#set -x
#=====================VARIABLES=======================
CURRENT_DIR=$(pwd)
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files/connect.py"
cd ${LAGO_DIR}/files
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'

#===============Checking file =========================

#======================================================

usage(){

#echo "$(basename $0) :USAGE"
echo $WHITE "${0} :UASGE";
echo $YELLOW	       "$0 -i | --input_inst [name] -ip | --input_ports  [name]";
echo "	            -o | --output_inst [name] -op | --output_ports [name] ";
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
#=========================================================================================
cd ${CURRENT_DIR}
if [[ -f *.sv ]]
then

	/bin/rm -r *.sv
	/bin/cp -r ${LAGO_DIR}/files/Baseboard/*.sv ${CURRENT_DIR}/
	/bin/cat *.sv
	exit 0
elif [[ ! -f *.sv ]]
then
	/bin/cp -r ${LAGO_DIR}/files/Baseboard/*.sv ${CURRENT_DIR}/
	/bin/cat *.sv
	exit 0
else
	echo "error in copying file:"
	echo "please look your file in : ${LAGO_DIR}/files/Baseboard"
	exit 1
fi
