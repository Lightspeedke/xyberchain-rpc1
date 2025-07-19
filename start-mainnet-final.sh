#!/bin/bash

echo "🌐 XYBERCHAIN MAINNET - FINAL VERSION"
echo "===================================="

# Configuration
DATADIR="./mainnet-data"
NETWORK_ID=9194
HTTP_PORT=8545
WS_PORT=8546
P2P_PORT=30303

# Create password file
echo "xyberchain-mainnet-secure-2024" > password.txt

# Kill existing
pkill -f geth
sleep 3

# Clean start
rm -rf $DATADIR

# Initialize with WORKING genesis
echo "📦 Initializing mainnet with PoW genesis..."
./geth-old --datadir $DATADIR init mainnet-genesis.json

# Import the pre-funded account
echo "🔑 Importing pre-funded account..."
echo "4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d" > temp_key.txt
./geth-old --datadir $DATADIR account import --password password.txt temp_key.txt
rm temp_key.txt

# Start mainnet
echo "🚀 Starting XYBERCHAIN MAINNET..."
echo "Network ID: $NETWORK_ID"
echo "HTTP RPC: http://0.0.0.0:$HTTP_PORT"
echo "WebSocket: ws://0.0.0.0:$WS_PORT"
echo "Pre-funded Account: 0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1"
echo ""

./geth-old --datadir $DATADIR \
    --networkid $NETWORK_ID \
    --http \
    --http.addr "0.0.0.0" \
    --http.port $HTTP_PORT \
    --http.corsdomain "*" \
    --http.vhosts "*" \
    --http.api "eth,net,web3,personal,admin,miner,txpool" \
    --ws \
    --ws.addr "0.0.0.0" \
    --ws.port $WS_PORT \
    --ws.api "eth,net,web3" \
    --ws.origins "*" \
    --port $P2P_PORT \
    --nat "extip:$(curl -s ifconfig.me)" \
    --mine \
    --miner.threads 2 \
    --miner.etherbase "0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1" \
    --unlock "0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1" \
    --password password.txt \
    --allow-insecure-unlock \
    --maxpeers 50 \
    --verbosity 3 \
    --syncmode "full" \
    --gcmode "archive"
