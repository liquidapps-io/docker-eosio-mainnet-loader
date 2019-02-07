# docker-eosio-mainnet-loader
The container image allows you to quickly bootstrap from snapshots and blocks log https://eosnode.tools

## Run
```
docker run --name mainnetloader -v /eos.data:/eos.data -t --rm -i liquidapps/eosio-mainnet-loader
```

You should now have the latest blocks log and corresponding snapshot ready to use in: /eos.data
