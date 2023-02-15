#!/bin/bash

LAGO_DIR=$(pwd);
FILE1=false;
FILE2=false;
FILE3=false;
#echo $LAGO_DIR
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
	sudo ln -s ${LAGO_DIR}/list_lago.sh lago_list;
	echo "======list_lago installed====";
	echo "+++++++++++++++++++++++++++++";
	cd $LAGO_DIR
	if [[ -f ~/.LAGO_USR_INFO ]]
	then
		/bin/rm -r ~/.LAGO_USR_INFO
		echo "LAGO_DIR=${LAGO_DIR}">~/.LAGO_USR_INFO;

	elif [[ -n ~/.LAGO_USR_INFO ]]
	then
		echo "LAGO_DIR=${LAGO_DIR}">~/.LAGO_USR_INFO;
	else
		echo "error: LAGO_USR_INFO is not written!";
		exit 1
	fi

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

CREATE_LINK

echo -e "USAGE:\nUse 'create' command to generate toplevel file\n eg: create -f clock.sv";
echo -e "\nAfter creating toplevel file use 'plug' command to the instances of file\n eg: plug -f up_counter.sv -i count_sec";
echo -e "\nAfter pluging instances use 'connect' command to connect instances \n eg: connect -i count_sec -ip clear -o count_min -op en ";
echo -e "\nHERE is a list of files you can plug to:";

./list_lago.sh
