# Your first smart contract

Our public [devnet](connect-to-devnet.md) is now live!

!!! warning
    The Hylé API is currently a basic proof of concept. Everything here will change and improve.

### Coding your smart contract

You can use [any zkVM or proving scheme supported by Hylé](../../roadmap/supported-proving-schemes.md).

For this example, we'll assume you're using the RISC Zero Collatz Conjecture program, which can be found [here](https://github.com/Hyle-org/collatz-conjecture). See the [Collatz example in depth](../examples/collatz-example-in-depth.md) page for more details.

<!--TODO: specify transaction format, ABI, etc.-->

### Installing the Hylé CLI tool

The simplest way to interact with Hylé is using `hyled`, the cosmos-SDK powered CLI.
[Follow the installation instructions](hyled-install-instructions.md).

Make sure you have a cosmos Address setup. We recommend also setting it as a variable for convenience.
Rename `my-key` to whatever you used when creating your key.
```bash
export ADDRESS=$(./hyled keys show my-key -a)
```

### Registering your smart contract

Hylé smart contracts are made of:

- a **Name**, which must be unique
- a **tuple of (verifier, program_id)** which identifies the smart contract. The `verifier` is the proof system (currently either "risczero" or "gnark-groth16-te-BN254"), and the `program_id` is the unique identifier of the program in that proof system, either the image ID in risczero of the verifying key in groth16 circuits.
- a **state digest**, holding the current state commitment of the contract. This can be any type of state commitment you want, and can currently be any size you want (this will have fee implications in the future).

To register a contract on-chain, run the following command:

```bash
# Owner is currently unused, but could be used in the future to manage contract permissions
hyled tx zktx register [owner] [contract_name] [verifier] [program_id] [state_digest] $ADDRESS
```

In the case of the Collatz Conjecture program, as RISC Zero programs are identified by their image ID, without a prefix, we use the number `0xb48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b`. This will change every time the contract logic is modified.  
The initial state is set to "1", so that it can be reset to any number. This is encoded in base 64 as `AAAAAQ==` (because of the rust library used to decode the state).

_NB: this might fail on the public devnet, as the contract name might already exist - try a different name in that case._

```bash
hyled tx zktx register $ADDRESS collatz risczero b48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b AAAAAQ== $ADDRESS
```

You can check on Hylé's explorer to see your transaction:  
`https://explorer.hyle.eu/Hylé/tx/$TXHASH` 

Your contract state is visible at:  
`https://explorer.hyle.eu/Hylé/cosmwasm/0/transactions?contract=$CONTRACT_NAME`

### Interacting with Hylé

#### Stateful transactions
Once your contract has been registered, you can send valid proofs of state transition to permissionlessly update the state of the smart contract.

Hylé requires some specific variables in the output of the proof to process the transaction.  
Check the [smart contract ABI](../general-doc/smart-contract-abi.md) for more details.

Each transaction can include multiple state transitions on multiple contracts. The first such payload is used as the Origin.
Using the CLI, this is done as follows:

```bash
# cosmos_signer is the address of the transaction signer in the Cosmos SDK
hyled tx zktx execute [[contract_name] [proof/receipt]] --from [cosmos_signer]
```

You can repeat the part between double-brackets as many times as you like, to send multiple state changes.

In the case of the Collatz Conjecture program, we can for example generate a proof of state transition from 1 to 24, and send it to the contract.

```bash
# Generate the proof in 'collatz-contract'
cargo run reset 24
cd ../hyle

# Make sure the name matches the contract you registered
hyled tx zktx execute collatz ../collatz-contract/proof.json --from $OWNER
```

You can then check that the contract was updated onchain by running the command below or checking in the explorer directly.
    
```bash
hyled query zktx contract collatz
```

#### Stateless transactions / Verification only

Hylé supports verification of transactions without state changes. This can be used either to aggregate proofs, or to do other coputations out-of-band or off-chain using the Hylé DA.
The format is similar to stateful transactions, and you still need a registered contract, but there is no need to provide the initial and final state.
```bash
# sender is the Cosmos SDK address of the transaction signer.
hyled tx zktx verify [contract_name] [receipt] [sender]
```
