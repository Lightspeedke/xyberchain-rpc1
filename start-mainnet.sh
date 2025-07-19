#!/bin/bash

echo "🌐 XYBERCHAIN MAINNET STARTUP"
echo "============================"

# Configuration
DATADIR="./mainnet-data"
NETWORK_ID=9194
HTTP_PORT=8545
WS_PORT=8546
P2P_PORT=30303

# Create password file
echo "your-secure-password-here" > password.txt

# Kill existing
pkill -f geth
sleep 3

# Initialize if needed
if [ ! -d "$DATADIR" ]; then
    echo "📦 Initializing mainnet..."
    ./geth-old --datadir $DATADIR init mainnet-genesis.json
    
    echo "🔑 Creating mainnet account..."
    ./geth-old --datadir $DATADIR account new --password password.txt
fi

# Get the first account
COINBASE=$(./geth-old --datadir $DATADIR account list | head -1 | cut -d'{' -f2 | cut -d'}' -f1)
echo "💰 Coinbase: $COINBASE"

# Start mainnet (FIXED - using old geth locally)
echo "🚀 Starting XYBERCHAIN MAINNET..."
echo "Network ID: $NETWORK_ID"
echo "HTTP RPC: http://0.0.0.0:$HTTP_PORT"
echo "WebSocket: ws://0.0.0.0:$WS_PORT"
echo "P2P Port: $P2P_PORT"
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
    --miner.etherbase $COINBASE \
    --unlock $COINBASE \
    --password password.txt \
    --allow-insecure-unlock \
    --maxpeers 50 \
    --verbosity 3 \
    --syncmode "full" \
    --gcmode "archive"
