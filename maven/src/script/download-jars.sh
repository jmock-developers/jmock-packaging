#!/bin/sh
# Script to download artifacts 
#  	- curl
#	- unzip 

if [ $# -lt 4 ]
then
	echo "usage: download-jars.sh <download-url> <download-zip> <download-dir> <download-name>"
	exit -1
fi

DOWNLOAD_URL=$1
DOWNLOAD_ZIP=$2
DOWNLOAD_DIR=$3
DOWNLOAD_NAME=$4

if [ -d "$DOWNLOAD_DIR/$DOWNLOAD_NAME" ] ; then
    echo "Directory $DOWNLOAD_DIR/$DOWNLOAD_NAME exists"
else
	curl $DOWNLOAD_URL/$DOWNLOAD_ZIP > $DOWNLOAD_DIR/$DOWNLOAD_ZIP
	unzip $DOWNLOAD_DIR/$DOWNLOAD_ZIP -d$DOWNLOAD_DIR
	rm $DOWNLOAD_DIR/$DOWNLOAD_ZIP
fi    

