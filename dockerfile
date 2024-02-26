FROM paritytech/ci-linux:production

ENV CARGO_HOME=/var/www/node-template/.cargo
WORKDIR /var/www/node-template

COPY . .
COPY ./config /var/www/node-template/.cargo/config

RUN cargo build --release --config net.git-fetch-with-cli=true -Z sparse-registry

ENTRYPOINT ["/var/www/node-template/entrypoint.sh"]

# # Generate key and extract Secret phrase and Account ID
# RUN ./target/release/node-template key generate --scheme Sr25519 > key_output1.txt && \
#     SECRET_PHRASE=$(grep "Secret phrase" key_output1.txt | awk -F':' '{print $2}' | xargs) && \
#     ACCOUNT_ID=$(grep "Account ID" key_output1.txt | awk '{print $NF}') && \
#     echo "Secret phrase: $SECRET_PHRASE" && \
#     echo "Account ID: $ACCOUNT_ID" && \
#     ./target/release/node-template key insert --chain customSpecRaw.json --scheme Sr25519 --suri "$SECRET_PHRASE" --key-type aura && \
#     echo "{\n\t\"jsonrpc\": \"2.0\",\n\t\"id\": 1,\n\t\"method\": \"author_insertKey\",\n\t\"params\": [\n\t\t\"aura\",\n\t\t\"$SECRET_PHRASE\",\n\t\t\"$ACCOUNT_ID\"\n\t]\n}" > key1.json

# RUN ./target/release/node-template key generate --scheme Ed25519 > key_output2.txt && \
#     SECRET_PHRASE=$(grep "Secret phrase" key_output2.txt | awk '{print $NF}') && \
#     ACCOUNT_ID=$(grep "Account ID" key_output2.txt | awk '{print $NF}') && \
#     echo "Secret phrase: $SECRET_PHRASE" && \
#     echo "Account ID: $ACCOUNT_ID" && \
#     ./target/release/node-template key insert --chain customSpecRaw.json --scheme Ed25519 --suri "$SECRET_PHRASE" --key-type gran && \
#     echo "{\n\t\"jsonrpc\": \"2.0\",\n\t\"id\": 1,\n\t\"method\": \"author_insertKey\",\n\t\"params\": [\n\t\t\"gran\",\n\t\t\"$SECRET_PHRASE\",\n\t\t\"$ACCOUNT_ID\"\n\t]\n}" > key2.json

# RUN ./target/release/node-template --base-path /home/blockchain --chain ./customSpecRaw.json --port 30333 --ws-port 9945 --rpc-port 9933 --telemetry-url 'wss://telemetry.polkadot.io/submit/ 0' --rpc-cors '*' --rpc-methods Unsafe --name blockchain --validator &

# RUN curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@key1.json"
# RUN curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@key2.json"
