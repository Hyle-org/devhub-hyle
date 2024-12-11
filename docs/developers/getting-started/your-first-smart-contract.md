# Your first smart contract

You can use [any zkVM or proving scheme supported by Hylé](../general-doc/supported-proving-schemes.md).

We'll use [the Collatz example](https://github.com/Hyle-org/collatz-conjecture) as an example throughout this tutorial. See the [Collatz page](../examples/collatz-example-in-depth.md) page for more information. This contract, based on Risc0, facilitates token swaps between two assets.

<!--TODO: specify transaction format, ABI, etc.-->

## Prerequisites

- A working knowledge of zkVM basics.
- For this example, [Rust](https://www.rust-lang.org/tools/install). We assume a typical Rust installation which contains both `rustup` and Cargo.
- [Follow the CLI installation instructions](install-cli.md). We are currently building utilities that will make it easier and faster to use our explorer, [Hyléou](../explorer/index.md).

## Registering your smart contract

Hylé smart contracts include:

- **Name**: a unique identifier for your contract
- **Tuple of (verifier, program_id)**: identifies the smart contract. The `verifier` is the proof system (e.g. "risczero" or "gnark-groth16-te-BN254"), and the `program_id` is the unique identifier of the program in that proof system. With Risc0, this is the image ID.
- **State digest**: current state commitment of the contract.

Read more about the [anatomy of smart contracts on Hylé](../general-doc/anatomy-smart-contracts.md).

To register a contract on Hylé, run the following command:

```bash
# Owner is currently unused, but could be used in the future to manage contract permissions
hyled tx zktx register [owner] [verifier] [program_id] [contract_name] [state_digest]
```

Replace `[owner], [verifier], [program_id], [contract_name]`, and `[state_digest]` with your specific details.

In the case of the Collatz Conjecture example, as RISC Zero programs are identified by their image ID, without a prefix, we use the number `0xb48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b`. This will change every time the contract logic is modified.  

The initial state is set to "1", so that it can be reset to any number. This is encoded in base 64 as `AAAAAQ==` (because of the Rust library used to decode the state).

For our example, the bash command would look like this:

```bash
hyled tx zktx register default risczero b48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b collatz AAAAAQ==
```

(We put « default » as the `owner`, but you can put anything you like. This field is currently not leveraged; it will be in future versions.)

!!! note
    You need a unique [contract_name]. If you encounter a failure on the public devnet, try another name.

## Interacting with Hylé

Hylé transactions are settled in two steps, following [pipelined proving principles](https://blog.hyle.eu/an-introduction-to-delayed-proving/).

1. **Publishing payloads**: send the input of your program to the network. 
2. **Posting proof of your payload**: generate and submit proofs validating your payload so Hylé will settle your transaction.

### Publishing payloads

The content of the payload is app-specific: it's the input of your program.

For the Collatz conjecture, this is a number encoded as a big-endian 32-bit integer.

```bash
payload='\x00\x00\x00\x05'
# Generate the proof in 'collatz-contract'
cargo run reset $payload
hyled tx zktx publish "" collatz $(echo $payload | base64)
# the "" is a placeholder for identity: it's empty, as Collatz doesn't handle identity
```

You can see your transaction on Hylé's explorer: `https://hyleou.hyle.eu/transaction/$TX_HASH`

At this point, your transaction has been sequenced, but not settled.

### Posting proofs of your payload to settle it

Hylé requires specific variables in the output of the proof to process the transaction. Check the [smart contract ABI](../general-doc/smart-contract-abi.md) for more details.

Once your program conforms to the ABI, you can generate proofs and send them to Hylé.

Each payload of a transaction must be proven separately for now, so you need to specify the index of the payload you're proving.

```bash
hyled tx zktx prove [tx_hash] [payload_index] [contract_name] [proof]
```

In the case of the Collatz Conjecture program, we can now prove our state transition from 1 to 5.

```bash
# Make sure the name matches the contract you registered
hyled tx zktx prove [tx_hash] 0 collatz [path_to_proof]
```

Hylé will now verify your proof. After verification, your transaction is settled, updating the state of the contract.

Your contract state is visible at: `https://hyleou.hyle.eu/contract/$CONTRACT_NAME`

You can choose to run the command below instead:

```bash
hyled query zktx contract collatz
```
