#!/bin/bash
source db_function.sh
TABLE=$1;
PRODUCTION_FILE=$2;
PROJECT_FILE=$3;


IFS=$'\n';
SCHEMA=($( cat $PRODUCTION_FILE | awk '{print ($2 =="") ? " " : $2;}' | cat ))

FIELD=()
TYPE=()
NULL=()
KEY=()
DEFAULT=()
EXTRA=()

for (( i = 0 ; i < ${#SCHEMA[@]} ;  i+=7 )) do
	FIELD+=(${SCHEMA[$i + 1]})
	TYPE+=(${SCHEMA[$i + 2]})
	NULL+=(${SCHEMA[$i + 3]})
	KEY+=(${SCHEMA[$i + 4]})
	DEFAULT+=(${SCHEMA[$i + 5]})
	EXTRA+=(${SCHEMA[$i + 6]})
done

PR_SCHEMA=($( cat $PROJECT_FILE | awk '{print ($2 =="") ? " " : $2;}' | cat ))


PR_FIELD=();
for (( i = 0 ; i < ${#PR_SCHEMA[@]} ;  i+=7 )) do
	PR_FIELD+=(${PR_SCHEMA[$i + 1]})
done

i=0;
for val in ${FIELD[@]} 
do
	res=$(containsElement $val ${PR_FIELD[@]})
	if [[ "$res" == "0" ]];
	then
		if [[ ${NULL[$i]} == "NO" ]];
		then
			NULL[$i]="NOT NULL" 
		else
			NULL[$i]="NULL"
		fi	
		
		  
		do_mysql_query << EOF
		 	ALTER TABLE $TABLE ADD ${FIELD[$i]} ${TYPE[$i]} ${KEY[$i]} ${NULL[$i]} ${EXTRA[$i]} DEFAULT ${DEFAULT[$i]};
EOF
	fi 
	i=$i+1;
done
