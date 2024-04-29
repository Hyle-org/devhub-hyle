# Your first smart contract

Hylé is not currently in [testnet](testnet.md), but we'll be soon !

!!! note
    The Hylé API is very much a POC for now, and everything here will change and improve
    In particular, requiring signers will soon be changed.

### Coding your smart contract

You can use any zkVM or proving scheme supported by Hylé, which are currently:
- groth16
- risc0

TODO: specify transaction format, ABI, etc.

### Installing the Hylé CLI tool

The simplest way to interact with Hylé is using `hyled`, the cosmos-SDK powered CLI.
Simply follow the [installation instructions](hyled-install-instructions.md).

### Configure your environment:
```bash
./scripts/configure.sh # to setup connection with nodes
./hyled keys add my-key # to create your key
```
### Claim some HYLE token on the faucet with your newly created address:
```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"denom":"hyle","address":"$ADDRESS"}' \
  https://faucet.testnet.hyle.eu/credit
```
### Check your balance:
```bash
./hyled query bank balance $ADDRESS hyle
```
You can also visit `https://explorer.hyle.eu/hyle/account/$ADDRESS`


### Registering your smart contract

Hylé smart contracts are made of:
- a Name, which must be unique
- a tuple of (verifier, program_id) which identifies the smart contract. The `verifier` is the proof system (currently either "risczero" or "groth16-twistededwards-BN254"), and the `program_id` is the unique identifier of the program in that proof system, either the image ID in risczero of the verifying key in groth16 circuits.
- a state digest, holding the current state commitment of the contract. This can be any type of state commitment you want, and can currently be any size you want (this will have fee implications in the future)

To register a contract on-chain, simply run the following command:

```bash
# Owner is the address of the contract owner, which must match the transaction signer for now.
hyled tx zktx register [owner] [contract_name] [verifier] [program_id] [state_digest]
```


You can check on Hyle's explorer to see your transaction:
`https://explorer.hyle.eu/hyle/tx/$TXHASH`
### Interacting with Hylé

Once your contract has been registered, you can send valid proofs of state transition to permissionlessly update the contract.

Note that the proofs must be "full", i.e. including the output of the computation.
This allows contracts to specify if the full state diff must be provided, which enables DA on the Hylé chain.
For private computations, you can simply provide a proof of state commitment transitions.

```bash
# Signer is the address of the transaction signer.
hyled tx zktx execute [contract_name] [receipt] [initial_state] [final_state] [signer]
```
