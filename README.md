# Quorum-n-nodes

Run multiple Quorum nodes in a single docker container

Inspired by https://github.com/ConsenSys/quorum-docker-Nnodes

I wanted to use Quorum for running tests in a C.I environment, also it was very important to me to have a known state, in this case I wanted to know the accounts as in Ganache. 

For instance, when we run [ganache-cli](https://github.com/trufflesuite/ganache-cli), we can specify a flag (-m or --mnemonic) in the cli options that makes the account generation deterministic, that means that every time you run ganache with a certain [mnemonic phrase](https://en.bitcoin.it/wiki/Seed_phrase) it will generate the same accounts.

Taking that idea, how could I extend that behaviour and always have already known accounts per node? So I managed to use the same private keys as in ganache (At this point only the first 4 accounts) and import each one to a different node. These account are also added to the "alloc" field in the genesis.json file and I added some initial ether.

## Commands

Get the latest version for the docker registry

> docker pull edsonalcala/quorum-n-nodes:1.1-alpine

If you want to build the image locally

> git clone https://github.com/EdsonAlcala/quorum-n-nodes

Then build the image

> docker build -t <container-name> .

## Usage

You can simply run:

> docker run -t -d --name quorum-n-nodes -p 22001-22004:22001-22004 edsonalcala/quorum-n-nodes:1.1-alpine

> docker exec -it quorum-n-nodes start-nodes

## Future work

Please refer to this issue to see the planned work

https://github.com/EdsonAlcala/quorum-n-nodes/issues/1

## Notes

To generate the extradata field in genesis.json

https://raw.githubusercontent.com/getamis/istanbul-tools/master/cmd/istanbul/example/config.toml

## References

https://github.com/jpmorganchase/quorum-examples/blob/master/examples/7nodes/tessera-init.sh

https://github.com/jpmorganchase/quorum-examples/blob/master/examples/7nodes/istanbul-start.sh

https://github.com/ethereum/go-ethereum/wiki/Setting-up-private-network-or-local-cluster

https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options

https://github.com/ConsenSys/qbc/blob/master/docs/HOWTO.md
