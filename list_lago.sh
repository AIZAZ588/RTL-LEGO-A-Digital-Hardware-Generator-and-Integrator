#!/bin/bash
. ~/.LAGO_USR_INFO
PATH="${LAGO_DIR}/files/library"
if [ -d $PATH ]
then
	cd $PATH
	/bin/tree
	exit
else
	echo "library files not exists";
	exit
fi
