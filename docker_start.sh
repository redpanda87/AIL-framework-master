#!/bin/bash
signalListener() {
    "$@" &
    pid="$!"
    trap "echo 'Stopping'; kill -SIGTERM $pid" SIGINT SIGTERM

    while kill -0 $pid > /dev/null 2>&1; do
        wait
    done
}


source ./AILENV/bin/activate
cd bin
 chmod +x ./LAUNCH.sh 
 chmod +x ./LAUNCH.sh -f

signalListener tail -f /dev/null $@

 chmod +x ./LAUNCH.sh -k
