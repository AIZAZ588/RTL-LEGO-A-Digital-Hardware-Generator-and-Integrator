#!/bin/bash

LAGO_DIR=$(pwd);
FILE1=false;
FILE2=false;
FILE3=false;

RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'

CREATE_LINK(){
if [[ ${FILE1} && ${FILE2} && ${FILE3} ]];
then
	cd /usr/bin/
	sudo ln -s  ${LAGO_DIR}/create.sh create;
	echo "+++++++++++++++++++++++++++++";
	echo "======create  installed======";
	sudo ln -s  ${LAGO_DIR}/plug.sh plug;
	echo "======plug    installed======";
	sudo ln -s  ${LAGO_DIR}/connect.sh connect;
	echo "======connect installed======";
	sudo ln -s ${LAGO_DIR}/list_lago.sh list_lago;
	echo "======list_lago installed===";
	sudo ln -s ${LAGO_DIR}/config.sh config;
	echo "======config installed=======";
	echo "+++++++++++++++++++++++++++++";
	cd $LAGO_DIR
	if [[ -f ~/.LAGO_USR_INFO ]]
	then
		/bin/rm -r ~/.LAGO_USR_INFO
		echo -n "LAGO_DIR=${LAGO_DIR}">~/.LAGO_USR_INFO;

	elif [[ -n ~/.LAGO_USR_INFO ]]
	then
		echo -n "LAGO_DIR=${LAGO_DIR}">~/.LAGO_USR_INFO;
	else
		echo "error: LAGO_USR_INFO is not written!";
		exit 1
	fi

		/bin/chmod u+x *.sh
		/bin/chmod u+x ${LAGO_DIR}/files/*.py

fi
}

if [ -e ./create.sh ];then
	FILE1=true;
else
	echo "create.sh not exists";
	echo "create.sh is not installed";
	exit 1;
fi
if [ -e ./plug.sh ];then
	FILE2=true;
else
	echo "plug.sh not exists";
	echo "plug.sh is not installed ";
	exit 1;
fi

if [ -e ./connect.sh ];then
	FILE3=true;
else
	echo "connect.sh not exists"
	echo "connect.sh is not installed"
	exit 1
fi

if [ -e ./config.sh ];then
	FILE4=true;
else
	echo "config.sh not exists"
	echo "config.sh is not installed"
	exit 1
fi

CREATE_LINK

echo -e -n ${WHITE} "USAGE:\nUse 'create' command to generate toplevel file\n eg:";./create.sh '-h';
echo -e -n ${WHITE}  "\nAfter creating toplevel file use 'plug' command to plug the instance of file\n eg:"; ./plug.sh '-h';
echo -e -n ${WHITE} "\nAfter pluging instances use 'connect' command to connect instances \n eg:";./connect.sh '-h';
echo -e -n ${WHITE} "\nUse config command to configure your Top_level_file"
echo -e -n ${WHITE} "\nUse 'list_lago' command to find avalible modules";./list_lago.sh '-h';
echo -e -n ${WHITE} "\nHERE is a list of files you can plug to:";
${LAGO_DIR}/list_lago.sh
