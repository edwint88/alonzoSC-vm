#!/bin/bash
DIRECTORY=/home/vagrant/cardano-my-node
NODE_CONFIG=testnet
PORT=6000
HOSTADDR=0.0.0.0
TOPOLOGY=${DIRECTORY}/${NODE_CONFIG}-topology.json
DB_PATH=${DIRECTORY}/db
SOCKET_PATH=${DIRECTORY}/db/socket
CONFIG=${DIRECTORY}/${NODE_CONFIG}-config.json
/usr/local/bin/cardano-node run +RTS -N -A16m -qg -qb -RTS --topology ${TOPOLOGY} --database-path ${DB_PATH} --socket-path ${SOCKET_PATH} --host-addr ${HOSTADDR} --port ${PORT} --config ${CONFIG}