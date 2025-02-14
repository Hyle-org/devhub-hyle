# Using a custom identity contract

## When to use identity contracts on Hylé

On Hylé, any smart contract can serve as proof of identity. This flexibility allows you to register your preferred identity source as a smart contract for account identification. Hylé also ships [a native `hydentity` contract](https://github.com/Hyle-org/hyle/tree/main/crates/contracts/hydentity) for simplicity.

This guide walks you through creating and deploying your first simple identity contract using Hylé and RISC Zero. We'll use [our simple identity example](https://github.com/Hyle-org/examples/tree/main/simple-identity), which mirrors our [simple token transfer example](./your-first-smart-contract.md).

For a deeper understanding of smart contracts, explore our [identity management documentation](../concepts/identity.md).

## Run the example

!!! warning
    Our examples work on Hylé v0.7.2. Subsequent versions introduce breaking changes which have not yet been reflected in our examples.

!!! info
    You can jump to [Code Snippets](#code-snippets) for an in-depth look at the contract.

### Prerequisites

- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- Install openssl-dev (e.g. `apt install openssl-dev` or `cargo add openssl`).
- For our example, [install RISC Zero](https://dev.risczero.com/api/zkvm/install).
- [Start a single-node devnet](./devnet.md). We recommend using [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) with `-e RISC0_DEV_MODE=1` for faster iterations during development.

### Build and register the identity contract

To build all methods and register the smart contract on the local node [from the source](https://github.com/Hyle-org/examples/blob/main/simple-identity/host/src/main.rs), from the cloned Examples folder, run:

```bash
cargo run -- register-contract
```

The expected output is `📝 Registering new contract simple_identity`.

### Register an account / Sign up

To register an account with a username (`alice`) and password (`abc123`), execute:

```sh
cargo run -- register-identity alice.simple_identity abc123
```

The node's logs will display:

```bash
INFO hyle::data_availability::node_state::verifiers: ✅ Risc0 proof verified.
INFO hyle::data_availability::node_state::verifiers: 🔎 Program outputs: Successfully registered identity for account: alice.simple_identity
```

### Verify identity / Login

To verify `alice`'s identity:

```bash
cargo run -- verify-identity alice.simple_identity abc123 0
```

This command will:

1. Send a blob transaction to verify `alice`'s identity.
1. Generate a ZK proof of that identity. It will only be valid once, thus the inclusion of a nonce.
1. Send the proof to the devnet.

Upon reception of the proof, the node will:

1. Verify the proof.
1. Settle the blob transaction.
1. Update the contract's state.

The node's logs will display:

```bash
INFO hyle::data_availability::node_state::verifiers: ✅ Risc0 proof verified.
INFO hyle::data_availability::node_state::verifiers: 🔎 Program outputs: Identity verified for account: alice.simple_identity
```

See your contract's state digest at: `https://hyleou.hyle.eu/contract/$CONTRACT_NAME`.

See your transaction on Hylé's explorer: `https://hyleou.hyle.eu/tx/$TX_HASH`.

## Development mode

We recommend activating [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) during your early development phase for faster iteration upon code changes with `-e RISC0_DEV_MODE=1`.

You may also want to get insights into the execution statistics of your project: add the environment variable `RUST_LOG="[executor]=info"` before running your project.

The full command to run your project in development mode while getting execution statistics is:

```bash
RUST_LOG="[executor]=info" RISC0_DEV_MODE=1 cargo run
```

## Code snippets

Find the full annotated code in [our examples repository](https://github.com/Hyle-org/examples/blob/main/simple-identity/host/src/main.rs).

!!! info
    Learn more on the [Transactions on Hylé](../concepts/transaction.md) page.

### Registering the contract

This part is the same as for [Your first smart contract](./your-first-smart-contract.md).

### Register an identity

#### Build the blob transaction

This is a simplified code snippet:

```rs
let action = RegisterIdentity {
    account: identity,
};
let blob = sdk::Blob {
    contract_name: contract_name,
    data: action.as_blob_data(), // Note: This function does not exist. Used here for clarity
};
let blob_tx = BlobTransaction {
    identity: identity,
    blobs: vec![blob],
};
```

You can compare these to the fields described in the [Transactions on Hylé](../concepts/transaction.md) page.

#### Prove the registration

##### On the backend side

(The backend is called "host" in Risc0.)

Hylé transactions are settled in two steps, following [pipelined proving principles](../concepts/pipelined-proving.md). After sending the blob, your transaction is sequenced, but not settled.

For the transaction to be settled, it needs to be proven. You'll start with building the contract input, specifying:

- the initial state
- the identity of the transaction initiator
- the transaction hash, which can be found in the explorer after sequencing
- information about the blobs.
  - The password as a private input for proof generation in `private_blob`
  - `blobs`: full list of blobs in the transaction (must match the blob transaction)
  - `index`: each blob of a transaction must be proven separately for now, so you need to specify the index of the blob you're proving.

```rs
// Build the contract input
let inputs = ContractInput {
    initial_state: initial_state.as_digest(),
    identity: blob_tx.identity,
    tx_hash: blob_tx_hash,
    private_blob: sdk::BlobData(password),
    blobs: blobs,
    index: sdk::BlobIndex(0),
};

```

##### On the contract side

(The contract is called "guest" in Risc0.)

These inputs are then used by the sdk to [initialize the contract](https://github.com/Hyle-org/examples/blob/main/simple-identity/methods/guest/src/main.rs#L8) :

```rust
    // Parse contract inputs
    let (input, action) = sdk::guest::init_raw::<IdentityAction>();
```

- The **input** variable is the above constructed **ContractInput**
- The **action** contains the `let action RegisterIdentity { account: identity };` defined in the blob.

The password is retrieved by the guest:

```rust
    // Extract private information
    let password = from_utf8(&input.private_blob.0).unwrap();
```

The action is then handled by the contract:

```rust
    // We clone the inital state to be updated
    let mut next_state: Identity = input.initial_state.clone();

    // Execute the given action
    let res = sdk::identity_provider::execute_action(&mut next_state, action, password);
```

And the contract then commits the new state:

```rust
    sdk::guest::commit(input, next_state, res);
```

The `guest::commit` function includes the `HyleOutput` as explained in [Transactions on Hylé](../concepts/transaction.md).

### Verify an identity

The process is the same as for registering a new identity, but the action is different:

```rs

let action = VerifyIdentity {
    account: identity,
    nonce,
};
```

Check the full annotated code in [our GitHub example](https://github.com/Hyle-org/examples/blob/main/simple-identity/host/src/main.rs).
