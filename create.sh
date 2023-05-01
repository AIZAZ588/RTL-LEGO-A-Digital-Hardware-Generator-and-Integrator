#!/bin/bash
#set -x
#=====================VARIABLES========================
CURRENT_DIR=$(pwd)
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files/create.py"
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'

#------------------FUNTIONS-----------------------------

usage(){

echo $WHITE "create :UASGE";
echo $YELLOW	       "create -f | --filename [name] ";
echo "             -i | --inputs   [name] -ir | --input_range  [a:b]  "
echo "	            -o | --outputs  [name] -or | --output_range [x:y]  ";

}

run(){

	${PATH} $@
    return 0

}


#-----------------------------------------------------

if [ $(($# % 2)) -ne 0 ];
then
	echo "One argument has no value!"
	usage				   
	exit 1
fi

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
	source ${LAGO_DIR}/tab_completion.sh
	exit 0
fi
