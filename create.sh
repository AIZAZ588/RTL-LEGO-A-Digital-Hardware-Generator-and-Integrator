#!/bin/bash
#set -x
#=====================VARIABLES=======================
#echo "my home is :" $(pwd)
CURRENT_DIR=$(pwd)
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files/create.py"
cd ${LAGO_DIR}/files
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'
#basename $PATH
#===============Checking file =========================

#if [[ ! -x $PATH ]]
#then
#	echo "Permission Granted!"
#	chmod u+x ${PATH}           #--> Error: chmod command not found!
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
echo $YELLOW	       "$0 -f | --filename [name] ";
echo "             -i | --inputs   [name] -ir | --input_range  [a:b]  "
echo "	            -o | --outputs  [name] -or | --output_range [x:y]  ";

}
if [ $(($# % 2)) -ne 0 ];
then
	echo "last argument has no value!"
	usage				    # $(expr $# % 2) -> is not wroking : command not found
	exit 1
fi


run(){

#echo "run is called"
#echo "file neme is : ${filename}";
#echo "input     is : ${inputs}";
#echo "input  ra is : ${i_range}";
#echo "output    is : ${outputs}";
#echo "output ra is : ${o_range}";
#echo "path is 	   : ${PATH}";

if [[ -n ${i_range} && -z ${inputs} ]]
then
	echo $RED "Error:input range : "${i_range}" has no inputs"
	usage
	exit 1
fi

if [[ -n ${o_range} && -z ${outputs}  ]]
then
	echo "output range : "${o_range}" has no outputs"
	usage
	exit 1
fi

if [[ -n ${filename} && -n ${inputs} && -n ${i_range} && -n ${outputs} && -n ${o_range} ]]
then
	${PATH} '-f' ${filename} '-i' ${inputs} '-ir' ${i_range} '-o' ${outputs} '-or' ${o_range}
	#exit 0

elif [[ -n ${filename} && -n ${inputs} && -n ${i_range} && -n ${outputs} ]]
then
	${PATH} '-f' ${filename} '-i' ${inputs} '-ir' ${i_range} '-o' ${outputs} '-or' 'none'
	#exit 0

elif [[ -n ${filename} && -n ${inputs} && -n ${i_range} ]]
then
	${PATH} '-f' ${filename} '-i' ${inputs} '-ir' ${i_range}
	#exit 0

elif [[ -n ${filename} && -n ${outputs} && -n ${o_range} ]]
then
	${PATH} '-f' ${filename} '-o' ${outputs} '-or' ${o_range}
	#exit 0

elif [[ -n ${filename} && -n ${inputs} ]]
then
	${PATH} '-f' ${filename} '-i' ${inputs} '-ir' 'none'
	#exit 0

elif [[ -n ${filename} && -n ${outputs} ]]
then
	${PATH} '-f' ${filename} '-o' ${outputs} '-or' 'none'
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

		-i | --inputs)
					if [[ ${2} = -* || -z ${2} ]]
					then
					   	 echo $RED "Error: inputs not found!";
						 usage
						 exit 1
			       		 else
      					 	 inputs=${2}
					fi
					;;

		-ir | --input_range)    if [[ ${2} = -* || -z ${2} ]]  #Reminder! -> allow value in only [a:b] formate
					then
						echo $RED "Error: input_range not found!";
						usage
						exit 1
					else
						i_range=${2}
					fi
					;;

		-o | --outputs)        if [[ ${2} = -* || -z  ${2} ]]
				       then
						echo $RED "Error: outouts not found";
						usage
						exit 1
				       else
						outputs=${2}
				       fi
				       ;;

		-or | --outout_range)
					if [[ ${2} = -* || -z ${2} ]]   #||! ${2} =~ ^\[[[:digit:]]+:[[:digit:]]+\]$ ]] #Reminder! -> allow value in only [a:b] formate
					then
						echo $RED "Error: output_range not found!";
						usage
						exit 1
					else
						#echo "-or is called!";
						o_range=${2}
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
	${PATH}
	#exit 0
fi
cd ${CURRENT_DIR}
if [[ -f *.sv ]]
then

	/bin/rm -r *.sv
	/bin/cp -r ${LAGO_DIR}/files/Baseboard/*.sv ${CURRENT_DIR}/
	#/bin/cat *.sv
	exit 0
elif [[ ! -f *.sv ]]
then
	/bin/cp -r ${LAGO_DIR}/files/Baseboard/*.sv ${CURRENT_DIR}/
	#/bin/cat *.sv
	exit 0
else
	echo "error in copying file:"
	echo "please look your file in : ${LAGO_DIR}/files/Baseboard"
	exit 1
fi
