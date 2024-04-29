# CLI Installation instructions

The simplest way to interact with Hylé is using `hyled`, the cosmos-SDK powered CLI.

Simply clone the [Hylé repository](https://github.com/Hyle-org/hyle) and install it.

## Mac, Linux, Windows with WSL

You will need to have installed `make` and `go`, v1.20 and above, on your system

Here are the commands:
```bash
git clone https://github.com/Hyle-org/hyle.git
cd hyle
make build # or make install
```

You can then get a list of commands with `hyled help`.

TODO: write some additional useful commands here

## Creating your wallet
### Configure your environment:
```bash
./scripts/configure.sh # to setup connection with nodes
./hyled keys add my-key # to create your key
export ADDRESS=$(./hyled keys show my-key -a) # for convenience
```
### Claim some HYLE token on the faucet with your newly created address:
```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data "{\"denom\":\"hyle\",\"address\":\"$ADDRESS\"}" \
  https://faucet.testnet.hyle.eu/credit
```
### Check your balance:
```bash
./hyled query bank balance $ADDRESS hyle
```
You can also visit `https://explorer.hyle.eu/hyle/account/$ADDRESS`