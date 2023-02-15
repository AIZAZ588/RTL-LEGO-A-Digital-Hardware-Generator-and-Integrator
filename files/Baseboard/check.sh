#!/bin/bash
if [ -f *.sv ]
then
	echo ".sv is present";
	cp -r *.sv ~/pract/
	echo "copyed"
else
	echo "sorry"
fi
