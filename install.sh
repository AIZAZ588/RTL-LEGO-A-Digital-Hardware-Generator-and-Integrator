#!/bin/bash
#set -x
LEGO_DIR=$(pwd);

RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
WHITE=$'\e[1;37m'
GREEN=$'\e[1;32m'

#checking if the package is installed or not
CHECK(){
    if [[ -n $(which $1) ]]
    then
        echo "$1 is installed"
    else
        echo "installing $1........"
        sudo apt install $1
    fi
}

CHECK_colorama(){
    if [[ -n $(pip list | grep colorama) ]]
    then
        echo "colorama installed"
    else
        echo "installing colorama........"
        pip install colorama
    fi
}

ADD_TAB_COMPLETION(){
	#adding tab_completion to etc/bash_completion.d
	if [[ -f /etc/bash_completion.d/tab_completion.sh ]]
	then
		echo ${YELLOW} "tab_completion is already installed";
	else
		sudo cp ${LEGO_DIR}/tab_completion.sh /etc/bash_completion.d/tab_completion.sh
		echo "tab_completion installed";
		echo -e ${GREEN}  "\nplease restart your terminal to apply changes"
	fi
}

CHECK_FOR_PYTHON_FILES(){
	if [[ -f ${LEGO_DIR}/files/create.py && -f ${LEGO_DIR}/files/plug.py && -f ${LEGO_DIR}/files/connect.py && -f ${LEGO_DIR}/files/add.py && -f ${LEGO_DIR}/files/rename.py && -f ${LEGO_DIR}/files/delete.py && -f ${LEGO_DIR}/list_lego.sh ]]
	then
		echo "python files are installed"
	else
		echo "python files are not present"
		exit 1
	fi
}
CHECK_LEGO_USR_INFO(){
	if [[ -f ~/.LEGO_USR_INFO ]]
	then
		echo "LEGO_USR_INFO is already written"
	else
		echo -n "LEGO_DIR=${LEGO_DIR}">~/.LEGO_USR_INFO;
	fi
}



CREATE_LINK()
{
	cd /usr/bin/
	sudo ln -s  ${LEGO_DIR}/files/create.py create;
	echo "+++++++++++++++++++++++++++++";
	echo "======create		installed======";
	sudo ln -s  ${LEGO_DIR}/files/plug.py plug;
	echo "======plug		installed======";
	sudo ln -s  ${LEGO_DIR}/files/connect.py connect;
	echo "======connect		installed======";
	sudo ln -s ${LEGO_DIR}/list_lego.sh list_lego;
	echo "======list_lego	installed===";
	sudo ln -s ${LEGO_DIR}/files/add.py add;
	echo "======add			installed=======";
	sudo ln -s ${LEGO_DIR}/files/rename.py rename;
	echo "======rename 		installed=======";
	sudo ln -s ${LEGO_DIR}/files/delete.py delete;
	echo "======delete 		installed=======";
	echo "+++++++++++++++++++++++++++++";
	cd $LEGO_DIR

		/bin/chmod +x *.sh
		/bin/chmod +x ${LEGO_DIR}/examples/*
		/bin/chmod +x ${LEGO_DIR}/files/*.py
}

if [[ -f /usr/bin/create && -f /usr/bin/plug && -f /usr/bin/connect ]]
then
	echo "LEGO is already installed";
	echo "Do you want to reinstall it? (y/n)";
	read ans
	if [[ $ans == "y" || $ans == "Y" ]]
	then
		/bin/rm /usr/bin/create
		/bin/rm /usr/bin/plug
		/bin/rm /usr/bin/connect
		/bin/rm /usr/bin/list_lego
		/bin/rm /usr/bin/add
		/bin/rm /usr/bin/rename
		/bin/rm /usr/bin/delete
		/bin/rm ~/.LEGO_USR_INFO
		/bin/rm /etc/bash_completion.d/tab_completion.sh
		CHECK_FOR_PYTHON_FILES
		CHECK_LEGO_USR_INFO
		CHECK python3
		CHECK pip
		CHECK tree
		CHECK_colorama
		CREATE_LINK
		ADD_TAB_COMPLETION
		${LEGO_DIR}/list_lego.sh
	else
		echo "LEGO is not installed";
		exit 1
	fi
else
	CHECK_FOR_PYTHON_FILES
	CHECK_LEGO_USR_INFO
	CHECK python3
	CHECK pip
	CHECK tree
	CHECK_colorama
	CREATE_LINK
	ADD_TAB_COMPLETION
	${LEGO_DIR}/list_lego.sh
fi

#echo -e -n ${WHITE} "USAGE:\nUse 'create' command to generate toplevel file\n eg:";./create.sh '-h';
#echo -e -n ${WHITE}  "\nAfter creating toplevel file use 'plug' command to plug the instance of file\n eg:"; ./plug.sh '-h';
#echo -e -n ${WHITE} "\nAfter pluging instances use 'connect' command to connect instances \n eg:";./connect.sh '-h';
#echo -e -n ${WHITE} "\nUse config command to configure your Top_level_file"
#echo -e -n ${WHITE} "\nUse 'list_lego' command to find avalible modules";./list_lego.sh '-h';
#echo -e -n ${WHITE} "\nHERE is a list of files you can plug to:";
