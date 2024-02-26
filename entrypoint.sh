#!/bin/bash

OUTPUT_AURA=$(./target/release/node-template key generate --scheme Sr25519)

# Extract the secret phrase and account ID
SECRET_PHRASE_AURA=$(echo "$OUTPUT_AURA" | grep "Secret phrase" | cut -d':' -f2 | xargs)
ACCOUNT_ID_AURA=$(echo "$OUTPUT_AURA" | grep "Account ID" | cut -d':' -f2 | xargs)

echo "Aura Secret phrase: $SECRET_PHRASE_AURA"
echo "Aura Account ID: $ACCOUNT_ID_AURA"

# Use the secret phrase and account ID
./target/release/node-template key insert --chain customSpecRaw.json --scheme Sr25519 --suri "${SECRET_PHRASE_AURA}" --key-type aura

cat <<EOF > key1.json
{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "author_insertKey",
    "params": [
        "aura",
        "${SECRET_PHRASE_AURA}",
        "${ACCOUNT_ID_AURA}"
    ]
}
EOF

OUTPUT_GRAN=$(./target/release/node-template key generate --scheme Ed25519)

# Extract the secret phrase and account ID
SECRET_PHRASE_GRAN=$(echo "$OUTPUT_GRAN" | grep "Secret phrase" | cut -d':' -f2 | xargs)
ACCOUNT_ID_GRAN=$(echo "$OUTPUT_GRAN" | grep "Account ID" | cut -d':' -f2 | xargs)

echo "Gran Secret phrase: $SECRET_PHRASE_GRAN"
echo "Gran Account ID: $ACCOUNT_ID_GRAN"

# Use the secret phrase and account ID
./target/release/node-template key insert --chain customSpecRaw.json --scheme Ed25519 --suri "${SECRET_PHRASE_GRAN}" --key-type gran

cat <<EOF > key2.json
{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "author_insertKey",
    "params": [
        "gran",
        "${SECRET_PHRASE_GRAN}",
        "${ACCOUNT_ID_GRAN}"
    ]
}
EOF

sleep 10
./target/release/node-template --base-path ./data --chain ./customSpecRaw.json --port 30333 --ws-port 9945 --rpc-port 9933 --telemetry-url 'wss://telemetry.polkadot.io/submit/ 0' --rpc-cors '*' --rpc-methods Unsafe --name blockchain --validator --bootnodes /ip4/52.82.78.66/tcp/30333/p2p/12D3KooWRJJ1qfwc1komLaYLf3TYRdwT6FkyhF52APdsn5qpxpSo &
sleep 10

curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@key1.json"
curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@key2.json"