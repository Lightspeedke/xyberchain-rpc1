#!/bin/bash

echo "🚂 XYBERCHAIN MAINNET - RAILWAY DEPLOYMENT"
echo "=========================================="

# Railway environment
PORT=${PORT:-8545}
DATADIR="./mainnet-data"
NETWORK_ID=9194

# Create a stronger password file
echo "${GETH_PASSWORD:-xyberchain-mainnet-railway-secure-2024}" > password.txt

# Initialize if needed
if [ ! -d "$DATADIR/geth" ]; then
    echo "📦 Initializing XYBERCHAIN mainnet..."
    ./geth --datadir $DATADIR init mainnet-genesis.json
    
    echo "🔑 Importing pre-funded account..."
    echo "4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d" > temp_key.txt
    ./geth --datadir $DATADIR account import --password password.txt temp_key.txt
    rm temp_key.txt
    
    echo "✅ XYBERCHAIN initialization complete!"
fi

echo "🚀 Starting XYBERCHAIN MAINNET..."
echo "📡 RPC Port: $PORT"
echo "🏭 Mining Address: 0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1"
echo "💰 Pre-funded Balance: 10,000+ XYB"
echo "⛏️  Mining: Enabled"
echo "🔓 Account: Auto-unlocked"
echo ""

# Start with enhanced unlock settings
exec ./geth --datadir $DATADIR \
    --networkid $NETWORK_ID \
    --http \
    --http.addr "0.0.0.0" \
    --http.port $PORT \
    --http.corsdomain "*" \
    --http.vhosts "*" \
    --http.api "eth,net,web3,personal,admin,miner,txpool,debug" \
    --mine \
    --miner.threads 1 \
    --miner.etherbase "0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1" \
    --unlock "0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1" \
    --password password.txt \
    --allow-insecure-unlock \
    --maxpeers 25 \
    --verbosity 3 \
    --syncmode "full" \
    --cache 256 \
    --nodiscover \
    --miner.gasprice 1000000000 \
    --txpool.pricelimit 0
