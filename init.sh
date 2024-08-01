#!/bin/sh

set -e

# set variables for the chain
VALIDATOR_NAME=validator1
CHAIN_ID=lazychain
BINARY=lazychaind
KEY_NAME=slothy
TOKEN_AMOUNT=10000000000000000000000000stake
STAKING_AMOUNT=1000000000stake
RELAYER_ADDRESS=lazy1avl4q6s02pss5q2ftrkjqaft3jk75q4ldesnwe

# reset any existing genesis/chain data
$BINARY tendermint unsafe-reset-all
$BINARY init $VALIDATOR_NAME --chain-id $CHAIN_ID

# update $BINARY configuration files to set chain details and enable necessary settings
# the sed commands here are editing various configuration settings for the $BINARY instance
# such as setting minimum gas prices, enabling the api, setting the chain id, setting the rpc address,
# adjusting time constants, and setting the denomination for bonds and minting.
sed -i'' -e 's/^minimum-gas-prices *= .*/minimum-gas-prices = "0stake"/' "$HOME"/.lazychain/config/app.toml
sed -i'' -e '/\[api\]/,+3 s/enable *= .*/enable = true/' "$HOME"/.lazychain/config/app.toml
sed -i'' -e 's/localhost/0.0.0.0/g' "$HOME"/.lazychain/config/app.toml
sed -i'' -e "s/^chain-id *= .*/chain-id = \"$CHAIN_ID\"/" "$HOME"/.lazychain/config/client.toml
sed -i'' -e '/\[rpc\]/,+3 s/laddr *= .*/laddr = "tcp:\/\/0.0.0.0:26657"/' "$HOME"/.lazychain/config/config.toml
sed -i'' -e 's/"time_iota_ms": "1000"/"time_iota_ms": "10"/' "$HOME"/.lazychain/config/genesis.json
sed -i'' -e 's/bond_denom": ".*"/bond_denom": "stake"/' "$HOME"/.lazychain/config/genesis.json
sed -i'' -e 's/mint_denom": ".*"/mint_denom": "stake"/' "$HOME"/.lazychain/config/genesis.json

# add a key to keyring-backend test
$BINARY keys add $KEY_NAME --keyring-backend test

# add a genesis account
$BINARY genesis add-genesis-account $KEY_NAME $TOKEN_AMOUNT --keyring-backend test
$BINARY genesis add-genesis-account $RELAYER_ADDRESS $TOKEN_AMOUNT

# set the staking amounts in the genesis transaction
$BINARY genesis gentx $KEY_NAME $STAKING_AMOUNT --chain-id $CHAIN_ID --keyring-backend test

# collect gentxs
$BINARY genesis collect-gentxs

# copy centralized sequencer address into genesis.json
# Note: validator and sequencer are used interchangeably here
ADDRESS=$(jq -r '.address' ~/.lazychain/config/priv_validator_key.json)
PUB_KEY=$(jq -r '.pub_key' ~/.lazychain/config/priv_validator_key.json)
jq --argjson pubKey "$PUB_KEY" '.consensus["validators"]=[{"address": "'$ADDRESS'", "pub_key": $pubKey, "power": "1", "name": "Rollkit Sequencer"}]' ~/.lazychain/config/genesis.json > temp.json && mv temp.json ~/.lazychain/config/genesis.json
PUB_KEY_VALUE=$(jq -r '.pub_key .value' ~/.lazychain/config/priv_validator_key.json)
jq --arg pubKey $PUB_KEY_VALUE '.app_state .sequencer["sequencers"]=[{"name": "test-1", "consensus_pubkey": {"@type": "/cosmos.crypto.ed25519.PubKey","key":$pubKey}}]' ~/.lazychain/config/genesis.json >temp.json && mv temp.json ~/.lazychain/config/genesis.json

# start the chain
$BINARY genesis validate
$BINARY start --rollkit.aggregator --rollkit.da_address http://da:7980 --rpc.laddr tcp://0.0.0.0:36657 --grpc.address 0.0.0.0:9290 --p2p.laddr "0.0.0.0:36656" --minimum-gas-prices="0stake" --api.enable --api.enabled-unsafe-cors --api.address tcp://0.0.0.0:1317
