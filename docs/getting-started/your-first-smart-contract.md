# Your first smart contract

Our public [devnet](connect-to-devnet.md) is now live!

!!! warning
    The Hylé API is currently a basic proof of concept. Everything here will change and improve.

### Coding your smart contract

You can use [any zkVM or proving scheme supported by Hylé](../about/supported-proving-schemes.md).

For this example, we'll assume you're using the RISC Zero Collatz Conjecture program, which can be found [here](https://github.com/Hyle-org/collatz-conjecture). See the [Collatz example in depth](collatz-example-in-depth.md) page for more details.

<!--TODO: specify transaction format, ABI, etc.-->

### Installing the Hylé CLI tool

The simplest way to interact with Hylé is using `hyled`, the cosmos-SDK powered CLI.
[Follow the installation instructions](hyled-install-instructions.md).

### Registering your smart contract

Hylé smart contracts are made of:

- a **Name**, which must be unique
- a **tuple of (verifier, program_id)** which identifies the smart contract. The `verifier` is the proof system (currently either "risczero" or "gnark-groth16-te-BN254"), and the `program_id` is the unique identifier of the program in that proof system, either the image ID in risczero of the verifying key in groth16 circuits.
- a **state digest**, holding the current state commitment of the contract. This can be any type of state commitment you want, and can currently be any size you want (this will have fee implications in the future).

To register a contract on-chain, run the following command:

```bash
# Owner is the address of the contract owner, which must match the transaction signer for now.
hyled tx zktx register [owner] [contract_name] [verifier] [program_id] [state_digest]
```

In the case of the Collatz Conjecture program, as RISC Zero programs are identified by their image ID, without a prefix, we use the number `8d1e2161eeac263044fdb880de8fd26dbc436065c689a41a1bf2125af30d6f80`. This will change every time the contract logic is modified.  
The initial state is set to "1", so that it can be reset to any number. This is encoded in base 64 as `AAAAAQ==` (because of the rust library used to decode the state).

_NB: this might fail on the public devnet, as the contract name might already exist - try a different name in that case._

```bash
# Replace $OWNER with your address
hyled tx zktx register $OWNER collatz risczero 8d1e2161eeac263044fdb880de8fd26dbc436065c689a41a1bf2125af30d6f80 AAAAAQ==
```

You can check on Hylé's explorer to see your transaction:  
`https://explorer.Hylé.eu/Hylé/tx/$TXHASH` 

Your contract state is visible at:  
`https://explorer.Hylé.eu/Hylé/cosmwasm/0/transactions?contract=$CONTRACT_NAME`

### Interacting with Hylé

#### Stateful transactions
Once your contract has been registered, you can send valid proofs of state transition to permissionlessly update the state of the smart contract.
Hylé requires some specific variables in the output of the proof to process the transaction, namely:

- the initial state
- the next state

This will change in the future to include caller address, block timestamp, etc.  
Other components can also be added, those will not be used by the Hylé protocol but will be provided as part of our [DA](../about/data-availability.md).  
For private computations, you can simply provide a proof of state commitment transitions.

```bash
# Signer is the address of the transaction signer.
hyled tx zktx execute [contract_name] [receipt] [initial_state] [final_state] [signer]
```

In the case of the Collatz Conjecture program, we can for example generate a proof of state transition from 1 to 24, and send it to the contract.

```bash
# Generate the proof in 'collatz-contract'
cargo run reset 24
cd ../hyle

# Make sure the name matches the contract you registered
hyled tx zktx execute collatz ../collatz-contract/proof.json AAAAAQ== AAAAGA== $OWNER
```

You can then check that the contract was updated onchain by running the command below or checking in the explorer directly.
    
```bash
hyled query zktx contract collatz
```

#### Stateless transactions / Verification only

Hylé supports verification of transactions without state changes. This can be used either to aggregate proofs, or to do other coputations out-of-band or off-chain using the Hylé DA.
The format is similar to stateful transactions, and you still need a registered contract, but there is no need to provide the initial and final state.
```bash
# Signer is the address of the transaction signer.
hyled tx zktx verify [contract_name] [receipt] [signer]
```
