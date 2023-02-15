#!/usr/bin/env bash
#set -x
#=====================VARIABLES=======================
CURRENT_DIR=$(pwd)
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files/plug.py"
cd ${LAGO_DIR}/files
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'

#===============Checking file =========================

#if [[ ! -x $PATH ]]
#then
#	chmod +x $PATH;           #--> Error: chmod command not found!
#
#elif [[ ! -e $PATH ]]
#then
#	echo "${PATH} NOT FOUND!";
#	exit 1
#fi

#======================================================

usage(){

#echo "$(basename $0) :USAGE"      # --> Error :basename command not found ??
echo $WHITE "${0} :UASGE";
echo $YELLOW	       "$0 -f | --filename [name]  -i | --instance_name [name] ";

}
#if [[ $(${#} + 2) != 0 ]]
#then
#	echo "last argument has no value!"
#	usage				    # $(expr $# % 2) -> is not wroking : command not found
#	exit 1
#fi


run(){

echo "run is called!";
echo "file name is : ${filename}";
echo "inst name is : ${inst_name}";

if [[ -n ${filename} && -n ${inst_name} ]]
then
	${PATH} '-f' ${filename} '-i' ${inst_name}
	#exit 0

elif [[ -n ${filename} ]]
then
	${PATH} '-f' ${filename}
	#exit 0

fi

}

if [[ $# -gt 1  ]]
then
	while [[ $# -gt 1 ]]
	do
		case ${1} in
		-f | --filename)       if [[ ${2} = -* || -z ${2} ]]
					then
						echo $RED "Error: file_name not found!";
						usage
						exit 1
					else
						filename=${2}
					fi
					;;

		-i | --instance_name)
					if [[ ${2} = -* || -z ${2} ]]
					then
					   	 echo $RED "Error: inputs not found!";
						 usage
						 exit 1
			       		 else
      					 	 inst_name=${2}
					fi
					;;
		*)  echo $RED "Error : Unknown argumment!";
		    usage
		    exit 1
		;;
		esac

	shift 2
	done
run
elif [[ $# -eq 1 && $1 = -h || $1 = --help ]]
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
	echo $RED "Error: required at leat one argument -f | --filename [name]"
	usage
	exit 1
fi
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
