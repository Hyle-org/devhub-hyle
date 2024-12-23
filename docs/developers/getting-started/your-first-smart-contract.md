# Your first smart contract

You can use [any zkVM or proving scheme supported by Hylé](../general-doc/supported-proving-schemes.md).

We'll use [the Collatz example](https://github.com/Hyle-org/examples/tree/main/collatz-conjecture-rust) as an example throughout this tutorial. See the [Collatz page](../examples/collatz-example-in-depth.md) page for more information.

Read more in our [anatomy of a smart contract](../general-doc/anatomy-smart-contracts.md).

## Prerequisites

- A working knowledge of zkVM basics.
- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- [Follow the CLI installation instructions](user-tooling.md). We are currently building utilities that will make it easier and faster to use our explorer, [Hyléou](../explorer.md).
- For our example, you'll need to [install RISC Zero](https://dev.risczero.com/api/zkvm/install).

## Registering your smart contract

### Content of a smart contract

Hylé smart contracts include:

- **Name**: the unique identifier for your contract
- **Verifier**: the proof system (e.g. "risc0" or "gnark-groth16-te-BN254")
- **Program ID**: the unique identifier for your program in that proof system
- **State digest**: current state commitment of the contract

Read more about the [anatomy of smart contracts on Hylé](../general-doc/anatomy-smart-contracts.md).

### Register your contract

To register a contract on Hylé, run the following command:

```bash
# Owner is currently unused, but could be used in the future to manage contract permissions
hyled contract [owner] [verifier] [program_id] [contract_name] [state_digest]
```

Replace `[owner], [verifier], [program_id], [contract_name]`, and `[state_digest]` with your specific details.

#### For Collatz

In the case of the Collatz Conjecture example, as RISC Zero programs are identified by their image ID, without a prefix, we use the number `0xb48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b`. This will change every time the contract logic is modified.  

The initial state is set to "1", so that it can be reset to any number. This is encoded in base 64 as `AAAAAQ==` because of the Rust library used to decode the state.

Note that you need a unique `contract_name`. If you try to test this example on the public devnet, we recommend putting a name that's not « collatz ».

For our example, the bash command looks like this:

```bash
hyled contract default risc0 b48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b collatz AAAAAQ==
```

(We put « default » as the `owner`, but you can put anything you like. This field is currently not leveraged; it will be in future versions.)

#### Checking your contract

In the explorer, this will look like this:

```rust
{
    "tx_hash": "ebecbf7458370d656772369df4a76c343b050e3fdbe4c1ceb7d54175ce290b60",
    "owner": "default",
    "verifier": "risc0",
    "program_id": [
        b48e70c79688b41fc8f0daf8370d1ddb3f44ada934c10c6e0b0f5915102a363b
    ],
    "state_digest": [
        AAAAAQ==
    ],
    "contract_name": "collatz"
}
```

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
hyled blobs "" collatz $(echo $payload | base64)
# the "" is a placeholder for identity: it's empty, as Collatz doesn't handle identity
```

You can see your transaction on Hylé's explorer: `https://hyleou.hyle.eu/transaction/$TX_HASH`

At this point, your transaction has been sequenced, but not settled.

### Posting proofs of your payload to settle it

Hylé requires specific variables in the output of the proof to process the transaction. Check the [smart contract ABI](../general-doc/smart-contract-abi.md) for more details.

Once your program conforms to the ABI, you can generate proofs and send them to Hylé.

Each payload of a transaction must be proven separately for now, so you need to specify the index of the payload you're proving.

```bash
hyled proof [tx_hash] [contract_name] [proof]
```

In the case of the Collatz Conjecture program, we can now prove our state transition from 1 to 5.

```bash
# Make sure the name matches the contract you registered
hyled proof [tx_hash] collatz [path_to_proof]
```

Hylé will now verify your proof. After verification, your transaction is settled, updating the state of the contract.

### Verifying your contract's state

Your contract's state digest is visible at: `https://hyleou.hyle.eu/contract/$CONTRACT_NAME`

You can choose to run the command below instead:

```bash
hyled state collatz
```
