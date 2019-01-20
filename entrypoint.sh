#!/bin/bash

privateKeys=("7734e0fbafd53efe9931c020144cca98db281ac4d770dd7d9ff1a516bf12f32b" "b76c87f92112b30fd1ee5357e5e91595d855f49e64dd5fd1ee6cf40105d1abc5" "7c89b4435aff63098bf00c41376c98146b36f1858f2de969b2cb1463dcd7db84" "83b287f6446bdf176a207d6f46f76151292acdeeb88d824c6de2ac00a4cd1685")

#### Create main directory ##################

nnodes=${#privateKeys[@]}

if [[ $nnodes < 2 ]]
then
    echo "ERROR: There must be more than one node."
    exit 1
fi

#### Create directories for each node's configuration ##################

echo '[1] Configuring for '$nnodes' nodes.'

n=1
for pk in ${privateKeys[*]}
do
    qd=qdata_$n
    mkdir -p $qd/{logs,keys}
    mkdir -p $qd/dd/geth
    let n++
done

ls 
pwd