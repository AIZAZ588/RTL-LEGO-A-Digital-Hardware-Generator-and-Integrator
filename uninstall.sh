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

if [[ -n $(/bin/find lago_list) ]]
then
	echo "------------------------------";
	sudo /bin/rm lago_list
	echo "-----lago_list uninstalled----";
else
	echo "lago_list was not installed";
fi
cd ~
if [[ -n $(find .LAGO_USR_INFO) ]]
then
	echo "------------------------------";
	sudo /bin/rm .LAGO_USR_INFO
	echo "-----create uninstalled-------";
else
	echo ".LAGO_USR_INFO not found!";
fi
	echo "-------------------------------";
