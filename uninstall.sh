#!/bin/bash
cd /usr/bin
if [[ -n $(/bin/find create) ]]
then
	echo "------------------------------";
	sudo /bin/rm create
	echo "-----create uninstalled-------";
else
	echo "create was not installed";
fi
if [[ -n $(/bin/find plug) ]]
then
	echo "------------------------------";
	sudo /bin/rm plug
	echo "-----plug uninstalled---------";
else
	echo "plug was not installed";
fi

if [[ -n $(/bin/find connect) ]]
then
	echo "------------------------------";
	sudo /bin/rm connect
	echo "-----connect uninstalled------";
else
	echo "create was not installed";
fi

if [[ -n $(/bin/find list_lago) ]]
then
	echo "------------------------------";
	sudo /bin/rm list_lago
	echo "----list_lago uninstalled----";
else
	echo "list_lago was not installed";
fi

if [[ -n $(/bin/find add) ]]
then
	echo "------------------------------";
	sudo /bin/rm add
	echo "----add uninstalled--------";
else
	echo "add was not installed";
fi

if [[ -n $(/bin/find rename) ]]
then
	echo "------------------------------";
	sudo /bin/rm rename
	echo "----rename uninstalled--------";
else
	echo "rename was not installed";
fi

if [[ -n $(/bin/find delete) ]]
then
	echo "------------------------------";
	sudo /bin/rm delete
	echo "----delete uninstalled--------";
else
	echo "delete was not installed";
fi

cd ~
if [[ -n $(find .LAGO_USR_INFO) ]]
then
	echo "------------------------------";
	sudo /bin/rm .LAGO_USR_INFO
	echo "---LAGO_USR_INFO uninstalled--";
else
	echo ".LAGO_USR_INFO not found!";
fi
	echo "-------------------------------";
complete -r create plug connect delete add rename