# Your first smart contract

We'll use [our sample ERC20-like contract `hyllar`](https://github.com/Hyle-org/examples/tree/simple_erc20/simple-erc20) as the basis for this tutorial.

Read more in our [anatomy of a smart contract](../general-doc/anatomy-smart-contracts.md).

## Prerequisites

- A working knowledge of zkVM basics.
- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- [Follow the CLI installation instructions](user-tooling.md). We are currently building utilities that will make it easier and faster to use our explorer, [Hyléou](../explorer.md).
- [Start a single-node devnet](./devnet.md).
- For our example, you'll need to [install RISC Zero](https://dev.risczero.com/api/zkvm/install). 

## Content of a smart contract

Hylé smart contracts include:

- **Owner**: put anything you like. This field is currently not leveraged but will be in future versions.
- **Verifier**: the proof system (e.g. "risc0" or "gnark-groth16-te-BN254").
- **Program ID**: the unique identifier for your program in that proof system.
- **Contract name**: the unique identifier for your contract.
- **State digest**: current state commitment of the contract, usually a MerkleRootHash of the contract's state.

Read more about the [anatomy of smart contracts on Hylé](../general-doc/anatomy-smart-contracts.md).

<!--## Start your devnet and install our CLI

See our instructions on [starting your devnet](./devnet.md) and [downloading our CLI](./user-tooling.md) if not already done.

 Montrer un exemple de repo à clone -> ça te donnera cet output qui te donne le program ID à register.
Pour ça, il faut que #tech fasse un exemple copier-coller avec un petit tooling à côté.
On l'a avec hyrun. Note for Alex: hyled risque de sauter. -->

## Register your contract on your local node

To build all methods and register the smart contract on the local node, run:

```bash
cargo run -- register 1000
```

On the node's logs, you should see a line stating: `📝 Registering new contract simple_token`.

To send 2 tokens to *Bob*, sending a blob transaction and a proof transaction associated with that, you can run:

```bash
cargo run -- transfer faucet.simple_token bob.simple_token 2
```

This will:

1. Send a blob transaction to transfer 2 tokens from `faucet` to `bob`
2. Generate a ZK proof of that transfer
3. Send the proof to the devnet.

Your node will then:

1. Verify the proof
1. Settle the blob transaction
1. Update the contract State

This example does not compose with an identity contract, thus no identity verification is made. This is the reason of the suffix `.simple_token` on the "from" & "to" transfer fields. More info on identity management will come in the documentation.

## Execute your project locally in development mode

We recommend activating [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) during your early development phase for faster iteration upon code changes with `-e RISC0_DEV_MODE=1`.

You may also want to get insights into the execution statistics of your project: add the environment variable `RUST_LOG="[executor]=info"` before running your project.

The full command to run your project in development mode while getting execution statistics is:

```bash
RUST_LOG="[executor]=info" RISC0_DEV_MODE=1 cargo run
```

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
- `state_digest`: usually a MerkleRootHash of the contract's state. For this example, we'll use `fd00e876481700000001106661756365742e687964656e74697479fd00e876481700000000`, a hexadecimal representation of the state encoded in binary format.

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
    "program_id":"e085fa46f2e62d69897fc77f379c0ba1d252d7285f84dbcc017957567d1e812f",
    "state_digest": "fd00e876481700000001106661756365742e687964656e74697479fd00e876481700000000",
    "contract_name": "hyllar"
}
```

## Interact with Hylé

Hylé transactions are settled in two steps, following [pipelined proving principles](../general-doc/pipelined-proving.md).

1. **Publishing your blob**: publish the blob of the final state.
2. **Posting proof of your blob**: publish proof of the final state.

### Publishing blobs

The content of the blob is app-specific: it's the input of your program.

For Hyllar, this is a binary representation of the `ERC20Action` struct as defined in the contract.

```bash
# Create blob
blob='{binary representation of the ERC20Action struct}'

# Generate the proof in 'hyllar'
cargo run reset $blob 
hyled blobs "" hyllar $(echo $blob | base64)
```

At this point, your transaction has been sequenced, but not settled.

### Posting proofs of your blob to settle it

Hylé requires specific variables in the output of the proof to process the transaction. Check the [smart contract ABI](../general-doc/smart-contract-abi.md) for more details.

Once your program conforms to the ABI, you can generate proofs and send them to Hylé.

Each blob of a transaction must be proven separately for now, so you need to specify the index of the blob you're proving.

```bash
hyled proof [tx_hash] [contract_name] [proof]
```

In the case of the Hyllar program, we can now prove our state transition:

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
