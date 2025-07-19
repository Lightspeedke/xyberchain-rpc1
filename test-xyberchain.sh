#!/bin/bash

echo "🧪 XYBERCHAIN MAINNET TEST"
echo "========================="

# Wait for startup
echo "Waiting for blockchain to start..."
sleep 5

RPC_URL="http://localhost:8545"

echo ""
echo "1. 🔗 Chain ID Test..."
CHAIN_ID=$(curl -s -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
  $RPC_URL)
echo "Result: $CHAIN_ID"

echo ""
echo "2. 🌐 Network Version Test..."
NET_VER=$(curl -s -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}' \
  $RPC_URL)
echo "Result: $NET_VER"

echo ""
echo "3. 💰 Pre-funded Account Balance..."
BALANCE=$(curl -s -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1","latest"],"id":1}' \
  $RPC_URL)
echo "Result: $BALANCE"

echo ""
echo "4. 📦 Current Block Number..."
BLOCK=$(curl -s -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  $RPC_URL)
echo "Result: $BLOCK"

echo ""
echo "5. ⛏️ Mining Status..."
MINING=$(curl -s -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_mining","params":[],"id":1}' \
  $RPC_URL)
echo "Result: $MINING"

echo ""
echo "6. 🏭 Coinbase (Mining Reward Address)..."
COINBASE=$(curl -s -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_coinbase","params":[],"id":1}' \
  $RPC_URL)
echo "Result: $COINBASE"

echo ""
echo "================================"
if echo "$CHAIN_ID" | grep -q "0x23ea" && echo "$BALANCE" | grep -q "0x"; then
    echo "🎉 XYBERCHAIN MAINNET IS WORKING!"
    echo ""
    echo "📋 CONNECTION INFO:"
    echo "   RPC URL: http://localhost:8545"
    echo "   Chain ID: 9194 (0x23ea)"
    echo "   Currency: XYB"
    echo "   Pre-funded: 0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1"
    echo ""
    echo "🚂 Ready for Railway deployment!"
else
    echo "❌ Some tests failed or blockchain still starting..."
    echo "💡 Try again in a few minutes (DAG generation takes time)"
fi
