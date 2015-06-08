#!/bin/bash
set -u

# Internal function not to be used directly
# $1=host $2=port $3=user $4=$password
function rabbitmq_prepare {
        local tmp=$IFS;
        IFS=$'\n';
        RABBIT_QUEUES_LIST=($(rabbitmqadmin -H $1 -P $2 --username=$3 --password=$4 list queues name messages | tail -n +4 |tr -d ' ' | awk 'BEGIN{FS="|"} { print $2}' |head -n -1));
        RABBIT_QUEUES_MESSAGES=($(rabbitmqadmin -H $1 -P $2 --username=$3 --password=$4 list queues name messages | tail -n +4 |tr -d ' ' | awk 'BEGIN{FS="|"} {if ($3 == "") {$3=0}; print $3}' |head -n -1));
        IFS=$"$tmp";
}

# Count the number of message currently residing inside a queue
# $host $port $user $pass $queue_name
function rabbitmq_get_queue_count {
        rabbitmq_prepare "$1" "$2" "$3" "$4"
        local i
        for (( i = 0; i < ${#RABBIT_QUEUES_LIST[@]}; i++ ))
        do
                if [ "${RABBIT_QUEUES_LIST[$i]}" == "$5" ]; then
                        echo ${RABBIT_QUEUES_MESSAGES[$i]};
                        break;
                fi
        done

}

