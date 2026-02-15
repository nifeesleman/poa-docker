# poa-docker

Private Proof of Authority (PoA) Ethereum network using [Clique](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-225.md) consensus. No puppeth—genesis and scripts are set up manually.

## Overview

- **Chain ID:** 12345  
- **Network ID:** 12345  
- **Consensus:** Clique (PoA), 5 second block time  
- **Signers:** Configured in `genesis.json` (each has 300 ETH in genesis)

## Prerequisites

- [geth](https://geth.ethereum.org/docs/getting-started/installing-geth) (Go Ethereum)
- Optional: `bootnode` (from older geth, e.g. `go install github.com/ethereum/go-ethereum/cmd/bootnode@v1.10.26`) if you use node 3 or a standalone bootnode for discovery

## Setup

1. **Initialize each node** with the Clique genesis (run from project root):

   ```bash
   cd ~/poa-docker
   geth --datadir node1 init genesis.json
   geth --datadir node2 init genesis.json
   geth --datadir node3 init genesis.json
   ```

2. **Keystores & password**  
   Place your account keystores in `node1/keystore/`, `node2/keystore/`, `node3/keystore/` and set the unlock password in `.password` (or use per-node `password.txt` and adjust the scripts).

## Running the network

Run from the **project root** (`~/poa-docker`).

**Option A – Node 3 as bootnode**  
Start node 3 first, then node 1 and 2 (scripts derive node 3’s enode from `node3/geth/nodekey` if present):

```bash
./start-node3.sh   # terminal 1 – RPC http://localhost:8547
./start-node1.sh   # terminal 2 – RPC http://localhost:8545
./start-node2.sh   # terminal 3 – RPC http://localhost:8546
```

**Option B – Standalone bootnode**  
If you run a separate bootnode (e.g. in `bnode/`):

```bash
BOOTNODE_URL="enode://...@127.0.0.1:0?discport=30301" ./start-node1.sh
BOOTNODE_URL="enode://...@127.0.0.1:0?discport=30301" ./start-node2.sh
```

## Scripts

| Script           | Purpose                          |
|------------------|----------------------------------|
| `start-node1.sh` | Start node 1 (port 30303, RPC 8545) |
| `start-node2.sh` | Start node 2 (port 30304, RPC 8546) |
| `start-node3.sh` | Start node 3 (port 30305, RPC 8547); can act as bootnode |

Scripts use absolute paths for `--datadir` and `--password`, so they work regardless of current directory.

## Security

- Do not commit `.password`, `*.key`, `info.txt`, or `node*/` data. They are listed in `.gitignore`.
- For production, avoid `--allow-insecure-unlock` and use a proper secret manager.

## License

See repository license.

---

Co-authored-by: Cursor cursoragent@cursor.com
