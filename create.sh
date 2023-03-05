#!/bin/bash
#set -x
#=====================VARIABLES=======================
#echo "my home is :" $(pwd)
CURRENT_DIR=$(pwd)
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files/create.py"
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'
#===============Checking file =========================

#======================================================

usage(){

echo $WHITE  "$(/bin/basename $0) :USAGE"
echo $YELLOW	       "create -f | --filename [name] ";
echo "             -i | --inputs   [name] -ir | --input_range  [a:b]  "
echo "	            -o | --outputs  [name] -or | --output_range [x:y]  ";

}
run(){

	#echo "run is called"
	#echo "path is 	   : ${PATH}";
	#echo "you entered : " $@
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
