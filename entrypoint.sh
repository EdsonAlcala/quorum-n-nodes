#!/bin/bash

privateKeys=("7734e0fbafd53efe9931c020144cca98db281ac4d770dd7d9ff1a516bf12f32b" "b76c87f92112b30fd1ee5357e5e91595d855f49e64dd5fd1ee6cf40105d1abc5" "7c89b4435aff63098bf00c41376c98146b36f1858f2de969b2cb1463dcd7db84" "83b287f6446bdf176a207d6f46f76151292acdeeb88d824c6de2ac00a4cd1685")

#### Create main directory ##################

nnodes=${#privateKeys[@]}

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

### Copy private keys to nodekey in each folder
n=1
for key in ${privateKeys[*]}
do
    qd=qdata_$n
    touch $qd/nodekey
    echo $key >> $qd/nodekey
    let n++
done

#### Make static-nodes.json and store keys #############################

echo '[2] Creating Enodes and static-nodes.json.'

echo "[" > static-nodes.json
n=1
for key in ${privateKeys[*]}
do
    qd=qdata_$n

    # Generate the node's Enode and key
    enode=`cat $qd/nodekey`
    echo "The current nodekey is '$enode'"
    enode=`bootnode -nodekey $qd/nodekey -writeaddress`

    # Add the enode to static-nodes.json
    sep=`[[ $n < $nnodes ]] && echo ","`
    echo '  "enode://'$enode'@0.0.0.0:3300'$n'?discport=0"'$sep >> static-nodes.json
    let n++
done
echo "]" >> static-nodes.json

#### Create accounts, keys and genesis.json file #######################

echo '[3] Creating Ether accounts and genesis.json.'

cat > genesis.json <<EOF
{
  "alloc": {
EOF

n=1
for privkey in ${privateKeys[*]}
do
    qd=qdata_$n

    # Generate an Ether account for the node
    touch $qd/password.txt
    account=`geth --datadir=$qd/dd --password $qd/password.txt account import $qd/nodekey | cut -c 11-50`
    echo "The account generated is '$account'"

    # Add the account to the genesis block so it has some Ether at start-up
    sep=`[[ $n < $nnodes ]] && echo ","`
    cat >> genesis.json <<EOF
    "${account}": {
      "balance": "1000000000000000000000000000"
    }${sep}
EOF

    let n++
done

cat >> genesis.json <<EOF
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "config": {
      "chainId": 2017,
      "homesteadBlock": 1,
      "eip150Block": 2,
      "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
      "eip155Block": 3,
      "eip158Block": 3,
      "istanbul": {
        "epoch": 30000,
        "policy": 0
      },
      "isQuorum": true
  },
  "extraData": "0x0000000000000000000000000000000000000000000000000000000000000000f89af854948304cb99e989ee34af465db1cf15e369d8402870941affe81865fa9b3184ddb6041fedc613054ddcc49488f4e7d08bd9216d682196dcbd8f087854da16d1947f4fd9bc518f560df6848837c657a7a9d1368bc1b8410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0",
  "gasLimit": "0xE0000000",
  "difficulty": "0x1",
  "mixHash": "0x63746963616c2062797a616e74696e65206661756c7420746f6c6572616e6365",
  "nonce": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x5c4527fa",
  "gasUsed": "0x0",
  "number": "0x0" 
}
EOF

# cat genesis.json 
# ls the genesis and static are in root (qdata)

#### Initialize nodes #######################

ARGS_NOMINER="--nodiscover --istanbul.blockperiod 5 --syncmode full --verbosity 5 --debug --metrics --gasprice 0 --nat none"
ARGS="--nodiscover --istanbul.blockperiod 5 --syncmode full --mine --minerthreads 1 --verbosity 5 --debug --metrics --gasprice 0 --nat none"
RPC_ARGS="--rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul"

#### Copy static-nodes.json to their respective folder #######################
n=1
for privkey in ${privateKeys[*]}
do
    qd=qdata_$n
    cp ./static-nodes.json $qd/dd
    let n++
done

#### Start node 1 #######################
geth --datadir qdata_1/dd init genesis.json
PRIVATE_CONFIG=ignore nohup geth --datadir qdata_1/dd --nodekey qdata_1/nodekey --networkid 2017 --identity "Node 1" $ARGS $RPC_ARGS --rpccorsdomain "*" --rpcport 22001 --port 33001 --unlock 0 --password qdata_1/password.txt 2>>qdata_1/logs/geth.log &

#### Start node 2 #######################
geth --datadir qdata_2/dd init genesis.json
PRIVATE_CONFIG=ignore nohup geth --datadir qdata_2/dd --nodekey qdata_2/nodekey --networkid 2017 --identity "Node 2" $ARGS $RPC_ARGS --rpccorsdomain "*" --rpcport 22002 --port 33002 --unlock 0 --password qdata_2/password.txt 2>>qdata_2/logs/geth.log &

#### Start node 3 #######################
geth --datadir qdata_3/dd init genesis.json
PRIVATE_CONFIG=ignore nohup geth --datadir qdata_3/dd --nodekey qdata_3/nodekey --networkid 2017 --identity "Node 3" $ARGS $RPC_ARGS --rpccorsdomain "*" --rpcport 22003 --port 33003 --unlock 0 --password qdata_3/password.txt 2>>qdata_3/logs/geth.log &

#### Start node 4 #######################
geth --datadir qdata_4/dd init genesis.json
PRIVATE_CONFIG=ignore nohup geth --datadir qdata_4/dd --nodekey qdata_4/nodekey --networkid 2017 --identity "Node 4" $ARGS $RPC_ARGS --rpccorsdomain "*" --rpcport 22004 --port 33004 --unlock 0 --password qdata_4/password.txt 2>>qdata_4/logs/geth.log &
