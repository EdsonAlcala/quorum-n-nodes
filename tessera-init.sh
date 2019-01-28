#!/bin/bash

echo "[*] Initialising Tessera configuration"

for i in {1..4}
do
    DDIR="/qdata/qdata_${i}/tessera${i}"
    mkdir -p ${DDIR}
    mkdir -p ${DDIR}/logs
    cp "keys/tm${i}.pub" "${DDIR}/tm.pub"
    cp "keys/tm${i}.key" "${DDIR}/tm.key"
    rm -f "${DDIR}/tm.ipc"

    cat <<EOF > ${DDIR}/tessera-config${i}.json
{
    "useWhiteList": false,
    "jdbc": {
        "username": "sa",
        "password": "",
        "url": "jdbc:h2:${DDIR}/db${i};MODE=Oracle;TRACE_LEVEL_SYSTEM_OUT=0",
        "autoCreateTables": true
    },
    "serverConfigs":[
        {
            "app":"ThirdParty",
            "enabled": true,
            "serverSocket":{
                "type":"INET",
                "port": 908${i},
                "hostName": "http://localhost"
            },
            "communicationType" : "REST"
        },
        {
            "app":"Q2T",
            "enabled": true,
            "serverSocket":{
                "type":"UNIX",
                "path":"${DDIR}/tm.ipc"
            },
            "communicationType" : "UNIX_SOCKET"
        },
        {
            "app":"P2P",
            "enabled": true,
            "serverSocket":{
                "type":"INET",
                "port": 900${i},
                "hostName": "http://localhost"
            },
            "sslConfig": {
                "tls": "OFF",
                "generateKeyStoreIfNotExisted": true,
                "serverKeyStore": "${DDIR}/server${i}-keystore",
                "serverKeyStorePassword": "quorum",
                "serverTrustStore": "${DDIR}/server-truststore",
                "serverTrustStorePassword": "quorum",
                "serverTrustMode": "TOFU",
                "knownClientsFile": "${DDIR}/knownClients",
                "clientKeyStore": "${DDIR}/client${i}-keystore",
                "clientKeyStorePassword": "quorum",
                "clientTrustStore": "${DDIR}/client-truststore",
                "clientTrustStorePassword": "quorum",
                "clientTrustMode": "TOFU",
                "knownServersFile": "${DDIR}/knownServers"
            },
            "communicationType" : "REST"
        }
    ],
    "peer": [
        {
            "url": "http://localhost:9001"
        },
        {
            "url": "http://localhost:9002"
        },
        {
            "url": "http://localhost:9003"
        },
        {
            "url": "http://localhost:9004"
        }
    ],
    "keys": {
        "passwords": [],
        "keyData": [
            {
                "privateKeyPath": "${DDIR}/tm.key",
                "publicKeyPath": "${DDIR}/tm.pub"
            }
        ]
    },
    "alwaysSendTo": []
}
EOF

done