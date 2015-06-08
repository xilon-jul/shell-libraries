#!/bin/bash
set -u

function join { local IFS="$1"; shift; echo "$*"; }

function explode {
        local fs="$1"
        shift;
        local ret="";
        local arr=( $* )
        let total=${#arr[@]}-1;
        for (( i = 0; i < ${#arr[@]}; i++ )); do
                if [ $i -eq $total ]; then
                        ret+="${arr[$i]}"
                else
                        ret+="${arr[$i]}$fs"
                fi
        done
        echo $ret;
}

# $user  $host $command
function remote_ssh_command {
        ssh $1@$2 "$3" &> /dev/null
        if [ "$?" -ne 0 ]; then
                err "Failed to execute remote ssh command on $1@$2"
                return 2
        fi
        info "$3 executed OK";
        return 1;
}

