#!/bin/bash
set -u

# ${parameter+alt_value}, ${parameter:+alt_value}
# If parameter set, use alt_value, else use null string.
if [ ! -n "${LOG_LEVEL+1}" ]; then
    LOG_LEVEL=debug
fi

loglevels=( debug info warn error crit emerg )

function log_set_level {
    LOG_LEVEL="$1"
}

function log { 
    # Get current index of current log level
    # Get current index of method log level
    local current_log_level_ind=-1
    local method_log_level_index=-1
    for ((i=0;i<${#loglevels[@]}; i++)); do
        local l=${loglevels[$i]}
        if [ $l == "$LOG_LEVEL" ]; then
            current_log_level_ind=$i
        fi
        if [ $l == "$1" ]; then
            method_log_level_index=$i
        fi
    done
    #echo "Current level = $current_log_level_ind / method = $method_log_level_index\n"
    if [ $current_log_level_ind -le $method_log_level_index ]; then
        printf "[%-5s]: %-70s\n"  "$1" "$2";
    fi
}

function err {
    log "error" "$1"
}

function warn {
    log "warn" "$1"
}

function info {
    log "info" "$1"
}

function debug {
    log "debug" "$1"
}

