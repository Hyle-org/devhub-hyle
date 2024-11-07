# Your first smart contract

Our [public devnet](connect-to-devnet.md) is now live!

**The Hylé API is currently a basic proof of concept. Everything here will change and improve.**

### Coding your smart contract

You can use [any zkVM or proving scheme supported by Hylé](../../roadmap/supported-proving-schemes.md).

For this example, we'll assume you're using the [RISC Zero Collatz Conjecture program](https://github.com/Hyle-org/collatz-conjecture). See the [Collatz example in depth](../examples/collatz-example-in-depth.md) page for more details.

<!--TODO: specify transaction format, ABI, etc.-->

### Installing the Hylé CLI tool

In this example, we'll show you how to use the CLI to register and interact with your smart contract.
It's likely easier and faster to use our explorer, [Hyléou](https://hyleou.hyle.eu).

To begin, [follow the CLI installation instructions](hyled-install-instructions.md).

### Registering your smart contract

Hylé smart contracts are made of:

- a **name**, which must be unique
- a **tuple of (verifier, program_id)** which identifies the smart contract. The `verifier` is the proof system (e.g. "risczero" or "gnark-groth16-te-BN254"), and the `program_id` is the unique identifier of the program in that proof system, either the image ID in risczero of the verifying key in groth16 circuits.
- a **state digest**, holding the current state commitment of the contract. This can be any type of state commitment you want, and can currently be any size you want (this will have fee implications in the future).

Read more about [anatomy of smart contracts on Hylé](../general-doc/anatomy-smart-contracts.md)

To register a contract on-chain, run the following command:

```bash
# Owner is currently unused, but could be used in the future to manage contract permissions
hyled tx zktx register [owner] [verifier] [program_id] [contract_name] [state_digest]
```

In the case of the Collatz Conjecture program, as RISC Zero programs are identified by their image ID, without a prefix, we use the number `0xb48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b`. This will change every time the contract logic is modified.  
The initial state is set to "1", so that it can be reset to any number. This is encoded in base 64 as `AAAAAQ==` (because of the rust library used to decode the state).

_NB: this might fail on the public devnet, as the contract name might already exist - try a different name in that case._

```bash
# Using "default" as an owner for now, but you cna put anything you like
hyled tx zktx register default risczero b48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b collatz AAAAAQ==
```

You can check on Hylé's explorer to see your transaction:  
`https://hyleou.hyle.eu/transaction/$TX_HASH`

Your contract state is visible at:  
`https://hyleou.hyle.eu/contract/$CONTRACT_NAME`

### Interacting with Hylé

#### Publishing payloads

Hylé transactions are settled in two steps. First - you send the payloads of your transaction to the network. These are application-specific data and will depend on how the contract is implemented.  In the case of the Collatz Conjecture program, this is a number encoded as a big-endian 32-bit integer.  Hence, the payloads correspond to the input of our program.

```bash
payload='\x00\x00\x00\x05'
# Generate the proof in 'collatz-contract'
cargo run reset $payload
hyled tx zktx publish "" collatz $(echo $payload | base64) # the "" is a placeholder for identity - Collatz doesn't handle identity so this is empty.
```

You should then be able to check your transaction on Hyléou.
At this point, your transaction has been sequenced, but not settled.

#### Posting proofs of your payload to settle it.

Hylé requires some specific variables in the output of the proof to process the transaction.  
Check the [smart contract ABI](../general-doc/smart-contract-abi.md) for more details.

Once your program conforms to the ABI, you can simply generate proofs and send them to Hylé.
Each payload of a transaction must be proven separately (for now), so you need to specify the index of the payload you're proving.

```bash
hyled tx zktx prove [tx_hash] [payload_index] [contract_name] [proof]
```

In the case of the Collatz Conjecture program, we can now prove our state transition from 1 to 5.

```bash
# Make sure the name matches the contract you registered
hyled tx zktx prove [tx_hash] 0 collatz [path_to_proof]
```

At this point, your transaction is settled and the state of the contract has been updated.
You can then check that the contract was updated onchain by running the command below or checking in the explorer directly.

```bash
hyled query zktx contract collatz
```
