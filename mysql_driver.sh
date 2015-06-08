#!/bin/bash

set -u

# Execute the MySQL query and store data into flatten array
#  args: host $port $user $pass $dbname $query [$query_is_file]
#  return 0 if query has returned ok, 1 in case of an error
function mysql_exec {
        
	if [ ! -z "$7" ] && [ -e "$6" ]; then
		mysql -B -A -u $3 -p$4 -h $1 -P  $2 -D $5 2>&1 < "$6"
	else
        	mysql -B -A -u $3 -p$4 -h $1 -P  $2 -D $5 -e "$6" 2>&1
	fi
	if [ $? -ne 0 ]; then
		MYSQL_ERROR="${result[@]}";
		return 1;
	fi
}


# Execute the MySQL query and store data into flatten array
#  args: host $port $user $pass $dbname $query [$query_is_file]
#  return 0 if query has returned ok, 1 in case of an error
function mysql_exec_and_store_result {
        local tmp="$IFS";
	IFS=$'\n'
	# Declare result variable local here because local acts as a command and prevent us from retrieving the mysql exit status
        local result=();
	if [ ! -z "$7" ] && [ -e "$6" ]; then
		result=($(mysql -B -A -u $3 -p$4 -h $1 -P  $2 -D $5 2>&1 < "$6"))
	else
        	result=($(mysql -B -A -u $3 -p$4 -h $1 -P  $2 -D $5 -e "$6" 2>&1));
	fi
	if [ $? -ne 0 ]; then
		MYSQL_ERROR="${result[@]:-}";
		return 1;
        elif [ -z ${result[@]:-} ]; then
                return 1;
        fi
	MYSQL_ERROR="";
	# Skip first header row
	IFS=$"$tmp"
	local store="";
	for row in "${result[@]:1}"; do
		store+=($row);
		local r=($row);
		MYSQL_COL_LENGTH=${#r[@]};
	done
	let MYSQL_LINE_LENGTH=${#result[@]:1}-1;
	# echo "Nb Line = $MYSQL_LINE_LENGTH, nb cols = $MYSQL_COL_LENGTH"
	# store variable contains a flatten 2 dimensial array with results from mysql data store
	# Make this variable available to function caller
	MYSQL_QUERY_STORE=(${store[@]});
	# Free ressource 
	unset store;
	return 0;
}

# This method is used for retrieving data previously fetched by the mysql_exec_and_store_result call
# This method provides a MYSQL_RESULT variable that when read after the invocation contains the actual value at line $1 and column $2
# @param $1 the line index
# @param $2 the column index
# @return 0 if value could be retrieved and stored, 1 if at least one index is out of bound 
function mysql_get_result {
	local index=$(( ($1 - 1) * $MYSQL_COL_LENGTH + $2 - 1 ));
	if (( $1 < 1 || $1 > $MYSQL_LINE_LENGTH )); then
		echo "Invalid line index out of bounds";
		return 1;
	fi
	if (( $2 < 1 || $2 > $MYSQL_COL_LENGTH )); then
		echo "Invalid column index out of bounds";
		return 1;
	fi
	MYSQL_RESULT=${MYSQL_QUERY_STORE[$index]};
	return 0;
}

# This function exits if the previous mysql query fails with an error statement
# @return void
function mysql_exit_on_error {
	if [ ! -z "$MYSQL_ERROR" ]; then
		echo "Mysql error : $MYSQL_ERROR";
		exit 1;
	fi
}


# Free ressources after a mysql query 
# @return void
function mysql_free_ressources {
	unset MYSQL_QUERY_STORE;
	unset MYSQL_COL_LENGTH;
	unset MYSQL_LINE_LENGTH;
	unset MYSQL_RESULT;
	unset MYSQL_ERROR;
}
