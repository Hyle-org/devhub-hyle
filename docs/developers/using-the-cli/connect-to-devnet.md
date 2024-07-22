# Connect to the public devnet

Hylé provides a public devnet where you can test your applications.

!!!note
    We currently make no guarantees on the public devnet stability. It can be reset at any time.
    We will keep this page updated with the latest information.

## Create your wallet on our public devnet

#### Configure your environment
```bash
# This script automatically sets up the devnet configuration
./scripts/configure.sh
# Create yourprivate key, you can name it however you want
./hyled keys add my-key
export ADDRESS=$(./hyled keys show my-key -a) # for convenience
```

#### Claim HYLE tokens on the faucet with your newly created address
```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data "{\"denom\":\"hyle\",\"address\":\"$ADDRESS\"}" \
  https://faucet.devnet.hyle.eu/credit
```
#### Check your balance
```bash
./hyled query bank balance $ADDRESS hyle
```
You can also visit `https://explorer.hyle.eu/hyle/account/$ADDRESS`

## URLs

- Explorer: [https://hyleou.hyle.eu/](https://hyleou.hyle.eu/)  
- Faucet: [https://faucet.devnet.hyle.eu/](https://faucet.devnet.hyle.eu/)  
- REST: [https://api.devnet.hyle.eu/](https://api.devnet.hyle.eu/)  
- RPC: [https://rpc.devnet.hyle.eu/](https://rpc.devnet.hyle.eu/)  
- CometBFT: [https://cometbft.devnet.hyle.eu/](https://cometbft.devnet.hyle.eu/)  
