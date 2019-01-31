#!/bin/bash

echo "Starting Tessera"

for i in {1..4}
do
    DDIR="qdata_$i/tessera$i"
    
    #Only set heap size if not specified on command line
    MEMORY="-Xms128M -Xmx128M"

    CMD="nohup java $MEMORY -jar /tessera/tessera-app.jar -configfile $DDIR/tessera-config$i.json"
    echo "$CMD >> qdata_$i/tessera$i/logs/tessera$i.log 2>&1 &"
    ${CMD} >> "qdata_$i/tessera$i/logs/tessera$i.log" 2>&1 &
    sleep 1
done

echo "Waiting until all Tessera nodes are running..."
DOWN=true
k=10
while ${DOWN}; do
    sleep 1
    DOWN=false
    for i in {1..4}
    do
        DDIR="qdata_$i/tessera$i"
        
        if [ ! -S "$DDIR/tm.ipc" ]; then
            echo "Node ${i} is not yet listening on tm.ipc"
            DOWN=true
        fi

        set +e
        #NOTE: if using https, change the scheme
        #NOTE: if using the IP whitelist, change the host to an allowed host
        result=$(curl -s http://localhost:900${i}/upcheck)
        set -e
        if [ ! "${result}" == "I'm up!" ]; then
            echo "Node ${i} is not yet listening on http"
            DOWN=true
        fi
    done

    k=$((k - 1))
    if [ ${k} -le 0 ]; then
        echo "Tessera is taking a long time to start.  Look at the Tessera logs in qdata/logs/ for help diagnosing the problem."
    fi
    echo "Waiting until all Tessera nodes are running..."

    sleep 5
done

echo "All Tessera nodes started..."

sleep 2

exit 0