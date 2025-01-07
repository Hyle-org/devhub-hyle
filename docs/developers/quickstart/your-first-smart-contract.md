# Your first smart contract

This guide will walk you through creating and deploying your first token transfer contract using Hylé's tools and infrastructure. We'll use [our sample token transfer example](https://github.com/Hyle-org/examples/tree/simple_erc20/simple-token) as the basis for this tutorial.

For an in-depth understanding of smart contracts, check out our [anatomy of a smart contract](../general-doc/smart-contracts.md).

## Example

### Prerequisites

- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- For our example, [install RISC Zero](https://dev.risczero.com/api/zkvm/install).
- [Start a single-node devnet](./devnet.md). We recommend using [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) with `-e RISC0_DEV_MODE=1` for faster iterations during development.

## Quickstart

### Build and register the contract

To build all methods and register the smart contract on the local node [from the source](https://github.com/Hyle-org/examples/blob/simple_erc20/simple-token/host/src/main.rs), run:

```bash
cargo run -- register 1000
```

The expected output is `📝 Registering new contract simple_token`.

### Transfer tokens

To transfer 2 tokens from `faucet` to `Bob`:

```bash
cargo run -- transfer faucet.simple_token bob.simple_token 2
```

This command will:

1. Send a blob transaction to transfer 2 tokens from `faucet` to `bob`.
2. Generate a ZK proof of that transfer.
3. Send the proof to the devnet.

### Verify settled state

Upon reception of the proof, the node will:

1. Verify the proof
1. Settle the blob transaction
1. Update the contract's state

The node's logs will display:

```bash
INFO hyle::data_availability::node_state::verifiers: ✅ Risc0 proof verified.
INFO hyle::data_availability::node_state::verifiers: 🔎 Program outputs: Transferred 2 to bob.simple_token
```

And on the following slot:

```bash
INFO hyle::data_availability::node_state: Settle tx TxHash("[..]")
```

#### Check onchain balance

Verify onchain balances:

```bash
cargo run -- balance faucet.simple_token
cargo run -- balance bob.simple_token
```

!!! note
    In this example, we do not verify the identity of the person who initiates the transaction. We use `.simple_token` as a suffix for the "from" and "to" transfer fields: usually, we'd use the identity scheme as the suffix. **More information about identity management will be added to the documentation in January 2025.**

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

Find the full annotated code in [our examples repository](https://github.com/Hyle-org/examples/blob/simple_erc20/simple-token/host/src/main.rs).

#### Setup commands and CLI

Set up commands and CLI. You need a unique `contract_name`: here, we use `"simple_token"`.

```rs
struct Cli {
    #[command(subcommand)]
    command: Commands,

    #[clap(long, short)]
    reproducible: bool,

    #[arg(long, default_value = "http://localhost:4321")]
    pub host: String,

    #[arg(long, default_value = "simple_token")]
    pub contract_name: String,
}

#[derive(Subcommand)]
enum Commands {
    Register {
        supply: u128,
    },
    Transfer {
        from: String,
        to: String,
        amount: u128,
    },
    Balance {
        of: String,
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
Commands::Register { supply } => {
        // Build initial state of contract
        let initial_state = Token::new(supply, format!("faucet.{}", contract_name).into());
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
    }
```

In [the explorer](https://hyleou.hyle.eu/), this will look like this:

```rs
{
    "tx_hash": "321b7a4b2228904fc92979117e7c2aa6740648e339c97986141e53d967e08097",
    "owner": "examples",
    "verifier": "risc0",
    "program_id":"e085fa46f2e62d69897fc77f379c0ba1d252d7285f84dbcc017957567d1e812f",
    "state_digest": "fd00e876481700000001106661756365742e687964656e74697479fd00e876481700000000",
    "contract_name": "simple_token"
}
```

#### Create blob transaction

```rs
    let blob_tx = BlobTransaction {
        identity: from.into(),
        blobs,
    };

    // Send the blob transaction
    let blob_tx_hash = client.send_tx_blob(&blob_tx).await.unwrap();
    println!("✅ Blob tx sent. Tx hash: {}", blob_tx_hash);
```

#### Prove the transaction

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
    let inputs = ContractInput::<Token> {
        initial_state,
        identity: from.clone().into(),
        tx_hash: "".into(),
        private_blob: sdk::BlobData(vec![]),
        blobs: blobs.clone(),
        index: sdk::BlobIndex(0),
    };
    
    // Generate the zk proof
    let receipt = prove(cli.reproducible, inputs).unwrap();

    let proof_tx = ProofTransaction {
        blob_tx_hash,
        proof: ProofData::Bytes(borsh::to_vec(&receipt).expect("Unable to encode receipt")),
        contract_name: contract_name.clone().into(),
    };
    
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

Check the full annotated code in [our GitHub example](https://github.com/Hyle-org/examples/blob/simple_erc20/simple-token/host/src/main.rs).
