#!/bin/bash
#set -x
#=====================VARIABLES=======================
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files"
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'
COL=$'\e[1;36m'


usage(){

echo $WHITE  "$(/bin/basename $0) : USAGE"
echo -e $YELLOW "\t     config [OPTION] [FILE_ARGUMENTS]"
echo  "[OPTION]:"
echo -e  "\t-r || --rename"
echo -e  "\t-d || --delete"
echo -e  "\t-c || --changeIOandRange"
echo -e  "\t-h || --help\n"

echo "[FILE_ARGUMENTS]:"
echo ${GREEN}
        ${PATH}/rename.py '-h'
echo ${COL}
	${PATH}/delete.py '-h'
echo ${WHITE}
	${PATH}/changeIOandRange.py '-h'
}

if [[ $1 = -r || $1 = --rename ]]
then
    shift 1
    ${PATH}/rename.py $@
    exit 0

elif [[ $1 = -d || $1 = --delete ]]
then
    shift 1
    ${PATH}/delete.py $@
    exit 0

elif [[ $1 = -c || $1 = --changeIOandRange ]]
then
    shift 1
    ${PATH}/changeIOandRange.py $@
    exit 0

elif [[ $1 = -h || $1 = --help  ]]
then
	usage
	exit 0
else
    echo $RED $1 ": invalid argument!"
    usage
    exit 1
fi
