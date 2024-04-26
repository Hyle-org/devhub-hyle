### Build your app:
Please refer to [CLI Installation instructions](hyled-install-instructions.md)

### Configure your environment:
Run 
```bash
./scripts/configure.sh
```

### Create your key: 
```bash
./hyled keys add my-key
```
### Claim some HYLE token on the faucet with your newly created address:
```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"denom":"hyle","address":"<your address>"}' \
  https://faucet.testnet.hyle.eu/credit
```
### Check your balance: 
```bash
./hyled query bank balance hyle1qx99uzzc0jmzn6apmacdcye4s8yf89w5qkumtq hyle
```

### Register your first contract, you can get details running:
```bash
./hyled tx zktx register --help
```
Here is an example:
```bash
./hyled tx zktx register alice secondContract risczero 390d14c0c0a3f5eaede8e9b43db2a3b911780cebe46b70ca8fd745d3ca60691d $(echo -n "2" | base64) --from my-key
```
### You can check on Hyle's explorer to see your transaction:
https://explorer.hyle.eu/hyle/tx/hash_of_your_tx

### Change your first contract state, you can get details running:
```bash
./hyled tx zktx execute --help
```
Here is an example:
```bash
./hyled tx zktx execute firstContract ~/risczerotuto-helloworld/hello-world/receipt.json "$(echo -n "2" | base64)" "$(echo -n "4" | base64)" --from my-key
```