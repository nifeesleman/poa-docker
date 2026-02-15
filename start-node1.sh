#!/usr/bin/env bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
# Bootnode: use BOOTNODE_URL env, or node 3's enode if node3/geth/nodekey exists
if [[ -z "$BOOTNODE_URL" ]]; then
  NODE3_KEY="${SCRIPT_DIR}/node3/geth/nodekey"
  if [[ -f "$NODE3_KEY" ]] && command -v bootnode &>/dev/null; then
    PUB=$(bootnode -nodekey "$NODE3_KEY" -writeaddress)
    BOOTNODE_URL="enode://${PUB}@127.0.0.1:30305"
  fi
fi
exec geth \
  --datadir "$SCRIPT_DIR/node1" \
  --networkid 12345 \
  --port 30303 \
  --authrpc.port 8551 \
  --bootnodes "${BOOTNODE_URL:-}" \
  --syncmode full \
  --unlock "0xDCde66ee47CA9f92EAd964DfB690b2Cfa20bd17A" \
  --password "$SCRIPT_DIR/.password" \
  --mine \
  --http --http.addr 0.0.0.0 --http.port 8545 \
  --http.api eth,net,web3,clique
