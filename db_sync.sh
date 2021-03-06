#!/bin/bash

source db_function.sh
getopt
FOLDER_PRODACTION=$1
FOLDER_PROJECT=$2

bash db_export.sh $FOLDER_PRODACTION

FILE_TABLES_PRODACTION=$FOLDER_PRODACTION'tables'
FILE_TABLES_PROJECT=$FOLDER_PROJECT'tables'

SQL_FOLDER=$FOLDER_PRODACTION'/sql/'
NOT_ISSET_TABLE=($( cat $FILE_TABLES_PRODACTION $FILE_TABLES_PROJECT | sort | uniq -u));

for TABLE in ${NOT_ISSET_TABLE[@]}
do
	FILE=$SQL_FOLDER$TABLE
	if [ -f $FILE ];
	then
		do_mysql_query < $FILE
	fi
done

while read -r TABLE;
do
	bash db_analyze.sh $TABLE $FOLDER_PRODACTION$TABLE $FOLDER_PROJECT$TABLE
done < $FILE_TABLES_PRODACTION

