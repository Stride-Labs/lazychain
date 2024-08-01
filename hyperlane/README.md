```bash
make install
```

```bash
lazychaind config set client chain-id lazychain
lazychaind config set client node tcp://127.0.0.1:36657
lazychaind config set client keyring-backend test

strided config chain-id stride-internal-1
strided config node https://stride-testnet-rpc.polkachu.com:443
strided config keyring-backend test
```

```bash
# lazy133xh839fjn9wxzg6vhc0370lcem8939zyvmttk
echo "join always addict position jungle jeans bus govern crack huge photo purse famous live velvet virtual weekend hire cricket media dignity wait load mercy" | \
 lazychaind keys add my-key --recover

# stride133xh839fjn9wxzg6vhc0370lcem8939z2sd4gn
echo "join always addict position jungle jeans bus govern crack huge photo purse famous live velvet virtual weekend hire cricket media dignity wait load mercy" | \
 strided keys add my-key --recover
```

```bash
# Back out to the same level as the lazychain repo
cd ..

git clone --depth 1 git@github.com:many-things/cw-hyperlane.git
cd cw-hyperlane
git checkout 4f5656d4704178ac54d10467ca7edc3df2312c4b
```

```bash
cp ../stride-lazychain/hyperlane/docker-compose.yaml example/docker-compose.yml

docker compose -f example/docker-compose.yml build lazychain

docker compose -f example/docker-compose.yml up da
docker compose -f example/docker-compose.yml up lazychain
```

```bash
docker exec -it lazychain \
 lazychaind tx bank send slothy lazy133xh839fjn9wxzg6vhc0370lcem8939zyvmttk \
 10000000stake -y --gas auto --gas-adjustment 1.5 --gas-prices 0.025stake \
 --keyring-backend test --node http://localhost:36657
```

```bash
yarn install
```

```bash
cp ../stride-lazychain/hyperlane/lazy-config.yaml config.yaml
rm -f context/lazychain.json && rm -f context/lazychain.config.json && echo "y" | yarn cw-hpl upload remote v0.0.6-rc8 -n lazychain
yarn cw-hpl deploy -n lazychain
```

```bash
echo '{
  "artifacts": {
    "hpl_mailbox": 362,
    "hpl_validator_announce": 363,
    "hpl_ism_aggregate": 364,
    "hpl_ism_multisig": 365,
    "hpl_ism_pausable": 366,
    "hpl_ism_routing": 367,
    "hpl_igp": 368,
    "hpl_hook_aggregate": 369,
    "hpl_hook_fee": 370,
    "hpl_hook_merkle": 371,
    "hpl_hook_pausable": 372,
    "hpl_hook_routing": 373,
    "hpl_hook_routing_custom": 374,
    "hpl_hook_routing_fallback": 375,
    "hpl_test_mock_hook": 376,
    "hpl_test_mock_ism": 377,
    "hpl_test_mock_msg_receiver": 378,
    "hpl_igp_oracle": 379,
    "hpl_warp_cw20": 380,
    "hpl_warp_native": 381
  },
  "deployments": {}
}' > context/stride-internal-1.json
```

```bash
cp ../stride-lazychain/hyperlane/stride-config.yaml config.yaml
yarn cw-hpl deploy -n stride-internal-1
```

```bash
echo '{
  "db": "/etc/data/db",
  "relayChains": "lazychain,strideinternal1",
  "allowLocalCheckpointSyncers": "true",
  "gasPaymentEnforcement": [{ "type": "none" }],
  "whitelist": [
    {
      "origindomain": [963],
      "destinationDomain": [1651]
    },
    {
      "origindomain": [1651],
      "destinationDomain": [963]
    }
  ],
  "chains": {
    "lazychain": {
      "signer": {
        "type": "cosmosKey",
        "key": "0xf0517040b5669e2d93ffac3a3616187b14a19ad7a0657657e0f655d5eced9e31",
        "prefix": "lazy"
      }
    },
    "strideinternal1": {
      "signer": {
        "type": "cosmosKey",
        "key": "0xf0517040b5669e2d93ffac3a3616187b14a19ad7a0657657e0f655d5eced9e31",
        "prefix": "stride"
      }
    }
  }
}' > example/hyperlane/relayer.json
```

```bash
echo '{
  "db": "/etc/data/db",
  "checkpointSyncer": {
    "type": "localStorage",
    "path": "/etc/validator/strideinternal1/checkpoint"
  },
  "originChainName": "strideinternal1",
  "validator": {
    "type": "hexKey",
    "key": "0xf0517040b5669e2d93ffac3a3616187b14a19ad7a0657657e0f655d5eced9e31"
  },
  "chains": {
    "strideinternal1": {
      "signer": {
        "type": "cosmosKey",
        "key": "0xf0517040b5669e2d93ffac3a3616187b14a19ad7a0657657e0f655d5eced9e31",
        "prefix": "stride"
      }
    }
  }
}' > example/hyperlane/validator.strideinternal1.json
```

```bash
echo '{
  "db": "/etc/data/db",
  "checkpointSyncer": {
    "type": "localStorage",
    "path": "/etc/validator/lazychain/checkpoint"
  },
  "originChainName": "lazychain",
  "validator": {
    "type": "hexKey",
    "key": "0xf0517040b5669e2d93ffac3a3616187b14a19ad7a0657657e0f655d5eced9e31"
  },
  "chains": {
    "lazychain": {
      "signer": {
        "type": "cosmosKey",
        "key": "0xf0517040b5669e2d93ffac3a3616187b14a19ad7a0657657e0f655d5eced9e31",
        "prefix": "lazy"
      }
    }
  }
}' > example/hyperlane/validator.lazychain.json
```

```bash
jq -s '.[0] * .[1]' context/{lazychain,stride-internal-1}.config.json | \
  jq '.chains |= with_entries(.value.gasPrice.amount |= tostring)' | \
  jq '.chains.strideinternal1.index.chunk |= 5' | \
  perl -pe 's/127.0.0.1/lazychain/' > \
  example/hyperlane/agent-config.docker.json
```

```bash
docker compose -f example/docker-compose.yml up -d validator-lazychain validator-strideinternal1 relayer
```

```bash
echo '{
  "type": "native",
  "mode": "collateral",
  "id": "TIA.stride-lazychain",
  "owner": "<signer>",
  "config": {
    "collateral": {
      "denom": "ibc/1A7653323C1A9E267FF7BEBF40B3EEA8065E8F069F47F2493ABC3E0B621BF793"
    }
  }
}' > example/warp/utia-stride.json

yarn cw-hpl warp create ./example/warp/utia-stride.json -n stride-internal-1
```

```bash
echo '{
  "type": "native",
  "mode": "bridged",
  "id": "TIA.stride-lazychain",
  "owner": "<signer>",
  "config": {
    "bridged": {
      "denom": "utia"
    }
  }
}' > example/warp/utia-lazychain.json

yarn cw-hpl warp create ./example/warp/utia-lazychain.json -n lazychain
```

```bash
yarn cw-hpl warp link \
  --asset-type native \
  --asset-id TIA.stride-lazychain \
  --target-domain 963 \
  --warp-address $(jq -r '.deployments.warp.native[0].hexed' context/lazychain.json) \
  -n stride-internal-1
```

```bash
yarn cw-hpl warp link \
  --asset-type native \
  --asset-id TIA.stride-lazychain \
  --target-domain 1651 \
  --warp-address $(jq -r '.deployments.warp.native[0].hexed' context/stride-internal-1.json) \
  -n lazychain
```

```bash
warp_contract_address=$(jq -r '.deployments.warp.native[0].address' context/stride-internal-1.json)
recipient=$(yarn cw-hpl wallet convert-cosmos-to-eth -n lazychain $(lazychaind keys show my-key -a) | perl -pe 's/0x0x//g')
strided tx wasm execute $warp_contract_address \
    '{"transfer_remote":{"dest_domain":963,"recipient":"'"$recipient"'","amount":"10000"}}' \
    --amount 10101ibc/1A7653323C1A9E267FF7BEBF40B3EEA8065E8F069F47F2493ABC3E0B621BF793 \
    --from my-key -y \
     --gas 2000000 --fees 1000ustrd
```

```bash
warp_contract_address=$(jq -r '.deployments.warp.native[0].address' context/lazychain.json)
recipient=$(yarn cw-hpl wallet convert-cosmos-to-eth -n stride-internal-1 $(strided keys show my-key -a) | perl -pe 's/0x0x//g')
lazychaind tx wasm execute $warp_contract_address \
    '{"transfer_remote":{"dest_domain":1651,"recipient":"'"$recipient"'","amount":"10000"}}' \
    --amount 10000factory/${warp_contract_address}/utia,101stake \
    --from my-key -y \
     --gas 2000000 --fees 50000stake
```
