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
echo $YELLOW	       "$0 -i | --input_inst [name] -ip | --input_ports  [name]";
echo "	            -o | --output_inst [name] -op | --output_ports [name] ";

}
#if [[ $(${#} + 2) != 0 ]]
#then
#	echo "last argument has no value!"
#	usage				    # $(expr $# % 2) -> is not wroking : command not found
#	exit 1
#fi

check(){

#echo "input inst    : ${i_inst}";
#echo "input port    : ${i_port}";
#echo "output inst   : ${o_inst}";
#echo "output port   : ${o_port}";

if [[ -z ${i_port} ]]
then
	echo $RED "Error:No input ports! ";
	usage
	exit 1
fi

if [[ -z ${i_inst} ]]
then
	echo $RED "Error:No input instance!;"
	usage
	exit 1

fi

if [[ -z ${o_port} ]]
then
	echo $RED "Error:No output ports! ";
	usage
	exit 1
fi

if [[ -z $o_inst ]]
then
	echo $RED "Error:No output instance! ";
	usage
	exit 1

fi
}

run(){

check		 #check for missing argumments

#if [[ -n ${i_inst} && -n ${i_port} && -n ${o_inst} && -n ${o_port} ]]
#then
${PATH} '-i' ${i_inst} '-ip' ${i_port} '-o' ${o_inst} '-op' ${o_port}
	#exit 0
#fi

}

if [[ $# -gt 1  ]]
then
	while [[ $# -gt 1 ]]
	do
		case ${1} in
		-i | --input_inst)     if [[ ${2} = -* || -z ${2} ]]
				       then
						echo $RED "Error:input instance not found!";
						usage
						exit 1
					else
						i_inst=${2}
					fi
					;;

		-ip | --input_ports)
					if [[ ${2} = -* || -z ${2} ]]
					then
					   	 echo $RED "Error:input port not found!";
						 usage
						 exit 1
			       		 else
      					 	 i_port=${2}
					fi
					;;

		-o | --output_inst)     if [[ ${2} = -* || -z  ${2} ]]
				        then
						echo $RED "Error:output instance not found!";
						usage
						exit 1
				        else
				  		o_inst=${2}
				        fi
				        ;;

		-op | --output_ports)
					if [[ ${2} = -* || -z ${2} ]] #Reminder! -> allow value in only [a:b] formate
					then
						echo $RED "Error:output ports not found!";
						usage
						exit 1
					else
						o_port=${2}
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
	echo $RED "Error:No argumments Entered!"
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
