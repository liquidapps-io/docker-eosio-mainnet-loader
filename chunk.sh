#!/bin/bash
set -e
LOG_FILE=$1
CHUNK_LOG_FILE=$2
LAST_SIZE_FILE=last_size
CURRENT_SIZE=`du -b $LOG_FILE | cut -d \t -f 1`

if [ -f $LAST_SIZE_FILE ]
then
	LAST_SIZE=`cat $LAST_SIZE_FILE`
	echo $CURRENT_SIZE > $LAST_SIZE_FILE
	dd bs=1 if=$1 skip=$LAST_SIZE of=$CHUNK_LOG_FILE
else
	echo "first time. no chunks. setting $LAST_SIZE_FILE"
	echo $CURRENT_SIZE > $LAST_SIZE_FILE
fi