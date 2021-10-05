#!/bin/bash
curl -s -o $NODE_HOME/testnet-topology.json "https://api.clio.one/htopology/v1/fetch/?max=20&magic=1097911063&customPeers=relays-new.cardano-testnet.iohkdev.io:3001:2"

# restart cardano-node after grab
sudo systemctl restart cardano-node