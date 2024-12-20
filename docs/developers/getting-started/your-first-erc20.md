# Your first smart contract

We'll use [our sample ERC20-like contract `hyllar`](https://github.com/Hyle-org/hyle/tree/main/contracts/hyllar) as the basis for this tutorial.

## Prerequisites

- A working knowledge of zkVM basics. <!-- Is this true?-->
- Install the [Rust toolchain](https://www.rust-lang.org/tools/install).
- [Follow the CLI installation instructions](install-cli.md). We are currently building utilities that will make it easier and faster to use our explorer, [Hyléou](../explorer/index.md). <!-- Is this still true?-->

## Content of a smart contract

Hylé smart contracts include:

- **Owner**: put anything you like. This field is currently not leveraged but will be in future versions.
- **Verifier**: the proof system (e.g. "risc0" or "gnark-groth16-te-BN254").
- **Program ID**: the unique identifier for your program in that proof system.
- **Contract name**: the unique identifier for your contract.
- **State digest**: current state commitment of the contract, usually a MerkleRootHash of the contract's state.

Read more about the [anatomy of smart contracts on Hylé](../general-doc/anatomy-smart-contracts.md).

## Register your contract

To register a contract on Hylé, run the following command:

```bash
# Owner is currently unused, but could be used in the future to manage contract permissions
hyled contract [owner] [verifier] [program_id] [contract_name] [state_digest]
```

Replace `[owner], [verifier], [program_id], [contract_name]`, and `[state_digest]` with your specific details.

!!! warning
    - You need a unique `contract_name`.
    - The state digest cannot be empty, even if your app is stateless.

For our example:

- `owner`: we put « default » as the `owner`, but you can put anything you like. This field is currently not leveraged; it will be in future versions.
- `verifier`: for this example, the verifier is `risc0`
- `program_id`: as RISC Zero programs are identified by their image ID, without a prefix, we use the number `0xe085fa46f2e62d69897fc77f379c0ba1d252d7285f84dbcc017957567d1e812f`. This will change every time the contract logic is modified.
- `contract_name`: hyllar
- `state_digest`: usually a MerkleRootHash of the contract's state. For this example, we'll use `fd00e876481700000001106661756365742e687964656e74697479fd00e876481700000000`

For our example, the bash command looks like this:

```bash
hyled contract default risc0 e085fa46f2e62d69897fc77f379c0ba1d252d7285f84dbcc017957567d1e812f hyllar fd00e876481700000001106661756365742e687964656e74697479fd00e876481700000000
```

### Check your contract

In [the explorer](https://hyleou.hyle.eu/), this will look like this:

```rust
{
    "tx_hash": "321b7a4b2228904fc92979117e7c2aa6740648e339c97986141e53d967e08097",
    "owner": "hyle",
    "verifier": "risc0",
    "program_id": "e085fa46f2e62d69897fc77f379c0ba1d252d7285f84dbcc017957567d1e812f",
    "state_digest": "fd00e876481700000001106661756365742e687964656e74697479fd00e876481700000000",
    "contract_name": "hyllar"
}
```

## Interact with Hylé

Hylé transactions are settled in two steps, following [pipelined proving principles](../general-doc/pipelined-proving.md).

1. **Publishing your blob**: publish the blob of the final state.
2. **Posting proof of your blob**: publish proof of the state transition.



### Publishing blobs

The content of the blob is app-specific: it's the input of your program.

For Hyllar, this is a binary representation of the `ERC20Action` struct as defined in the contract.

!!! failure
    Section is currently being re-written, sorry.

<!-- RECOMMENCE CHACAL

```bash
# Create blob
blob='{binary representation of the ERC20Action struct}'
# Generate the proof in 'hyllar'
cargo run reset $blob 
hyled blobs "" collatz $(echo $blob | base64)
# the "" is a placeholder for identity: it's empty, as Collatz doesn't handle identity -> Replace with ERC20
```

-->

At this point, your transaction has been sequenced, but not settled.

### Posting proofs of your blob to settle it

Hylé requires specific variables in the output of the proof to process the transaction. Check the [smart contract ABI](../general-doc/smart-contract-abi.md) for more details.

Once your program conforms to the ABI, you can generate proofs and send them to Hylé.

Each blob of a transaction must be proven separately for now, so you need to specify the index of the blob you're proving.

```bash
hyled proof [tx_hash] [contract_name] [proof]
```

In the case of the Hyllar program, we can now prove our state transitio:

```bash
# Make sure the name matches the contract you registered
hyled proof [tx_hash] hyllar [path_to_proof]
```

Hylé will now verify your proof. After verification, your transaction is settled, updating the state of the contract.

You can see your transaction on Hylé's explorer: `https://hyleou.hyle.eu/transaction/$TX_HASH`

### Verifying your contract's state

Your contract's state digest is visible at: `https://hyleou.hyle.eu/contract/$CONTRACT_NAME`

You can choose to run the command below instead:

```bash
hyled state hyllar
```
