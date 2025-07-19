#!/bin/bash

echo "🌐 XYBERCHAIN MAINNET - USING OLD GETH"
echo "====================================="

# Check if old geth exists
if [ ! -f "./geth-old" ]; then
    echo "❌ ERROR: geth-old binary not found!"
    echo "Downloading old Geth version..."
    
    wget -q https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.26-e5eb32ac.tar.gz
    tar -xzf geth-linux-amd64-1.10.26-e5eb32ac.tar.gz
    cp geth-linux-amd64-1.10.26-e5eb32ac/geth ./geth-old
    chmod +x ./geth-old
    rm -rf geth-linux-amd64-1.10.26-e5eb32ac*
    
    echo "✅ Downloaded geth-old successfully!"
fi

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

# Check if genesis exists
if [ ! -f "mainnet-genesis.json" ]; then
    echo "❌ ERROR: mainnet-genesis.json not found!"
    echo "Please create it first!"
    exit 1
fi

# Initialize with OLD GETH and WORKING genesis
echo "📦 Initializing mainnet with OLD GETH..."
./geth-old --datadir $DATADIR init mainnet-genesis.json

# Import the pre-funded account
echo "🔑 Importing pre-funded account..."
echo "4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d" > temp_key.txt
./geth-old --datadir $DATADIR account import --password password.txt temp_key.txt
rm temp_key.txt

# Start mainnet with OLD GETH
echo "🚀 Starting XYBERCHAIN MAINNET with OLD GETH..."
echo "Network ID: $NETWORK_ID"
echo "HTTP RPC: http://0.0.0.0:$HTTP_PORT"
echo "Pre-funded Account: 0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1"
echo "Balance: 10,000 XYB"
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
