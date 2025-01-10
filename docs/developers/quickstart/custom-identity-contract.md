# Using a custom identity contract

## When to use identity contracts on Hylé

On Hylé, any smart contract can serve as proof of identity. This flexibility allows you to register your preferred identity source as a smart contract for account identification. Hylé also ships [a native `hydentity` contract](https://github.com/Hyle-org/hyle/tree/main/contracts/hydentity) for simplicity.

This guide walks you through creating and deploying your first simple identity contract using Hylé and RISC Zero. We'll use [our simple identity example](https://github.com/Hyle-org/examples/tree/simple_erc20/simple-identity), which mirrors our [simple token transfer example](./your-first-smart-contract.md).

For a deeper understanding of smart contracts, explore our [identity management documentation](../general-doc/identity.md).

## Quickstart

### Prerequisites

- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- [Install OpenSSL crate](https://crates.io/crates/openssl).
- For our example, [install RISC Zero](https://dev.risczero.com/api/zkvm/install).
- [Start a single-node devnet](./devnet.md). We recommend using [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) with `-e RISC0_DEV_MODE=1` for faster iterations during development.

### Build and register the identity contract

To build all methods and register the smart contract on the local node [from the source](https://github.com/Hyle-org/examples/blob/simple_erc20/simple-token/host/src/main.rs), from the cloned Examples folder, run:

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
cargo run -- verify-identity pseudo.simple_identity password --nonce 0
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

## Detailed information

### Development mode

We recommend activating [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) during your early development phase for faster iteration upon code changes with `-e RISC0_DEV_MODE=1`.

You may also want to get insights into the execution statistics of your project: add the environment variable `RUST_LOG="[executor]=info"` before running your project.

The full command to run your project in development mode while getting execution statistics is:

```bash
RUST_LOG="[executor]=info" RISC0_DEV_MODE=1 cargo run
```

### Code snippets

Find the full annotated code in [our examples repository](https://github.com/Hyle-org/examples/blob/main/simple-identity/host/src/main.rs).

#### Setup commands and CLI

Set up commands and CLI. You need a unique `contract_name`: here, we use `"simple_identity"`.

```rs
struct Cli {
    #[command(subcommand)]
    command: Commands,

    #[clap(long, short)]
    reproducible: bool,

    #[arg(long, default_value = "http://localhost:4321")]
    pub host: String,

    #[arg(long, default_value = "simple_identity")]
    pub contract_name: String,
}

#[derive(Subcommand)]
enum Commands {
    RegisterContract {},
    RegisterIdentity {
        identity: String,
        password: String,
    },
    VerifyIdentity {
        identity: String,
        password: String,
        nonce: u32,
    },
}
```

#### Registering the contract

Set up information about your contract. To register the contract, you'll need:

- `owner`: we put "examples" as the `owner`, but you can put anything you like. This field is currently not leveraged; it will be in future versions.
- `verifier`: for this example, the verifier is `risc0`
- `program_id`: RISC Zero programs are identified by their image ID, without a prefix.
- `state_digest`: usually a MerkleRootHash of the contract's initial state. For this example, we use a hexadecimal representation of the state encoded in binary format. The state digest cannot be empty, even if your app is stateless.
- `contract_name` as set up above.

```rs
// Build initial state of contract
let initial_state = Identity::new();
println!("Initial state: {:?}", initial_state);

// Send the transaction to register the contract
let register_tx = RegisterContractTransaction {
    owner: "examples".to_string(),
    verifier: "risc0".into(),
    program_id: sdk::ProgramId(sdk::to_u8_array(&GUEST_ID).to_vec()),
    state_digest: initial_state.as_digest(),
    contract_name: contract_name.clone().into(),
};
let res = client
    .send_tx_register_contract(&register_tx)
    .await
    .unwrap()
    .text()
    .await
    .unwrap();

println!("✅ Register contract tx sent. Tx hash: {}", res);
```

In the explorer, it will look like this:

```json
{
    "tx_hash": "321b7a4b2228904fc92979117e7c2aa6740648e339c97986141e53d967e08097",
    "owner": "examples",
    "verifier": "risc0",
    "program_id":"e085fa46f2e62d69897fc77f379c0ba1d252d7285f84dbcc017957567d1e812f",
    "state_digest": "fd00e876481700000001106661756365742e687964656e74697479fd00e876481700000000",
    "contract_name": "simple_identity"
}
```

#### Register an identity

```rs
// Fetch the initial state from the node
let initial_state: Identity = client
    .await
    .unwrap()
    .state
    .into();
```

##### Build the blob transaction

```rs
let action = sdk::identity_provider::IdentityAction::RegisterIdentity {
    account: identity.clone(),
};
let blobs = vec![sdk::Blob {
    contract_name: contract_name.clone().into(),
    data: sdk::BlobData(
        bincode::encode_to_vec(action, bincode::config::standard())
            .expect("failed to encode BlobData"),
    ),
}];
let blob_tx = BlobTransaction {
    identity: identity.into(),
    blobs: blobs.clone(),
};

// Send the blob transaction
let blob_tx_hash = client.send_tx_blob(&blob_tx).await.unwrap();
println!("✅ Blob tx sent. Tx hash: {}", blob_tx_hash);
```

##### Prove the registration

Hylé transactions are settled in two steps, following [pipelined proving principles](../general-doc/pipelined-proving.md). After this step, your transaction is sequenced, but not settled.

For the transaction to be settled, it needs to be proven. You'll start with building the contract input, specifying:

- the initial state as set above
- the identity of the transaction initiator
- the transaction hash, which can be found in the explorer after sequencing (currently, this can be ignored; it will be necessary after an upcoming update)
- information about the blobs.
  - private input for proof generation in `private_blob`
  - `blobs`: full list of blobs in the transaction (must match the blob transaction)
  - `index`: each blob of a transaction must be proven separately for now, so you need to specify the index of the blob you're proving.

```rs
// Build the contract input
let inputs = ContractInput {
    initial_state: initial_state.as_digest(),
    identity: blob_tx.identity,
    tx_hash: "".into(),
    private_blob: sdk::BlobData(password.into_bytes().to_vec()),
    blobs: blobs.clone(),
    index: sdk::BlobIndex(0),
};

// Generate the zk proof

(…)

// Send the proof transaction
let proof_tx_hash = client
    .send_tx_proof(&proof_tx)
    .await
    .unwrap()
    .text()
    .await
    .unwrap();
println!("✅ Proof tx sent. Tx hash: {}", proof_tx_hash);
```

#### Verify an identity

The process is the same as for registering a new identity.

```rs
// Fetch the initial state from the node
let initial_state: Identity = client
    .get_contract(&contract_name.clone().into())
    .await
    .unwrap()
    .state
    .into();
// ----
// Build the blob transaction
// ----

let action = sdk::identity_provider::IdentityAction::VerifyIdentity {
    account: identity.clone(),
    nonce,
};
let blobs = vec![sdk::Blob {
    contract_name: contract_name.clone().into(),
    data: sdk::BlobData(
        bincode::encode_to_vec(action, bincode::config::standard())
            .expect("failed to encode BlobData"),
    ),
}];
let blob_tx = BlobTransaction {
    identity: identity.into(),
    blobs: blobs.clone(),
};
```

Check the full annotated code in [our GitHub example](https://github.com/Hyle-org/examples/blob/main/simple-identity/host/src/main.rs).
