#!/bin/bash
source db_function.sh
DIR=$1
DIR_TABLE_SQL=$DIR"sql"
if  [ -d $DIR ]; then
	rm -r $DIR;
fi

mkdir $DIR
chmod 777 $DIR
mkdir $DIR_TABLE_SQL;
chmod 777 $DIR_TABLE_SQL

TABLE_FILE=$DIR'tables';
do_mysql_query << EOF
SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_schema='u7006751_oc' INTO OUTFILE '$TABLE_FILE';
EOF

while  read -r line;
do
FILE=$DIR'/'$line

do_mysql_query << EOF > $FILE
desc $line\G
EOF

FILE=$DIR_TABLE_SQL$line;
do_mysql_query << EOF > $FILE
SHOW CREATE TABLE $line;	
EOF

done < $TABLE_FILE

