# Proof composition with Ticket-App

Hylé's native proof verification allows for proof composition. To understand the concept better, we recommend you [read this blog post](https://blog.hyle.eu/proof-composability-on-hyle/).

This guide walks you through creating and deploying your first ticket transfer contract, based on a ticket-app and a simple-token app, by using Hylé and RISC Zero.

Find the source code here:

- [ticket-app](https://github.com/Hyle-org/examples/tree/feat/ticket-app/ticket-app)
- [simple-token](https://github.com/Hyle-org/examples/tree/feat/ticket-app/simple-token)

## Quickstart

### Prerequisites

- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- [Install OpenSSL crate](https://crates.io/crates/openssl).
- For our example, [install RISC Zero](https://dev.risczero.com/api/zkvm/install).
- [Start a single-node devnet](./devnet.md). We recommend using [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) with `-e RISC0_DEV_MODE=1` for faster iterations during development.

### Simple-token preparation

#### Register simple-token

Go to `./simple-token` folder and run:

```bash
cargo run -- --contract-name simple-token register 1000
```

On the node's logs, you will see:

> 📝 Registering new contract simple_token

You just registered a token contract named simple-token with an initial supply of 1000.

#### Transfer tokens

Now let's transfer some tokens to our user *bob*.

To send 50 tokens to *bob* and 10 tokens to *alice*, run:

```bash
cargo run -- -contract-name simple-token transfer faucet.simple-token bob.ticket-app 50
cargo run -- -contract-name simple-token transfer faucet.simple-token alice.ticket-app 10
```

The node's log will show:

> INFO hyle::data_availability::node_state::verifiers: ✅ Risc0 proof verified.
>
> INFO hyle::data_availability::node_state::verifiers: 🔎 Program outputs: Transferred 50 to bob.ticket_app
> INFO hyle::data_availability::node_state::verifiers: 🔎 Program outputs: Transferred 10 to alice.ticket_app

#### Check onchain balance

Check onchain balance:

```bash
cargo run -- --contract-name simple-token balance faucet.simple-token

cargo run -- --contract-name simple-token balance bob.ticket-app
cargo run -- --contract-name simple-token balance alice.ticket-app
```

!!! note
    The example does not compose with an identity contract, thus no identity verification is made.
    This is the reason for the suffix ".simple-token" and ".ticket-app" on the "from" & "to" transfer fields.
    More info to come in the documentation.

### Ticket-app

Now that *bob* has some tokens, let's buy him a ticket.

#### Register ticket-app

Register the ticket app by going to `./ticket-app` folder and running:

```bash
cargo run -- --contract-name ticket-app register simple-token 15
```

Our ticket app is called ticket-app, and sells a ticket for 15 simple-token.

#### Buy a ticket

Let's buy a ticket for *bob*:

```bash
cargo run -- --contract-name ticket-app --user bob.ticket-app buy-ticket
```

Let's try with *alice*:

```bash
cargo run -- --contract-name ticket-app --user alice.ticket-app buy-ticket
```

You will get an error while executing the TicketApp program: `Execution failed ! Program output: Insufficient balance`. This is because Alice has a balance of 10 and the ticket costs 15.

#### Check ticket and token balance

Check that *bob* has a ticket:

```bash
cargo run -- --contract-name ticket-app --user bob.ticket-app has-ticket
```

You can also check Bob's balance and see he now has 35 tokens.

## Code snippets

Find the full annotated code in [our examples repository](https://github.com/Hyle-org/examples/blob/main/ticket-app/host/src/main.rs).

### Setup commands and CLI

Set up commands and CLI. You need a unique `contract_name`: here, we use `"simple_ticket_app"`.

```rs
struct Cli {
    #[command(subcommand)]
    command: Commands,

    #[clap(long, short)]
    reproducible: bool,

    #[arg(long, default_value = "http://localhost:4321")]
    pub host: String,

    #[arg(long, default_value = "simple_ticket_app")]
    pub contract_name: String,

    #[arg(long, default_value = "examples.simple_ticket_app")]
    pub user: String,
}

#[derive(Subcommand)]
enum Commands {
    Register { token: String, price: u128 },
    BuyTicket {},
    HasTicket {},
}
```

### Registering the contract

Set up information about your contract.

```rs
// Build initial state of contract
let initial_state = TicketAppState::new(vec![], (ContractName(token), price));
println!("Initial state: {:?}", initial_state);
println!("Initial State {:?}", initial_state.as_digest());

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

#### Allow to buy a ticket

```rs
// Build initial state of contract
let initial_state: TicketAppState = client
    .get_contract(&contract_name.clone().into())
    .await
    .unwrap()
    .state
    .into();
```

#### Build the blob transaction

```rs
let blobs = vec![
    // identity_cf.as_blob(ContractName("hydentity".to_owned())),
    // Init pair 0 amount
    sdk::Blob {
        contract_name: initial_state.ticket_price.0.clone(),
        data: sdk::BlobData(
            bincode::encode_to_vec(
                sdk::erc20::ERC20Action::Transfer {
                    recipient: contract_name.clone(),
                    amount: initial_state.ticket_price.1,
                },
                bincode::config::standard(),
            )
            .expect("Failed to encode Erc20 transfer action"),
        ),
    },
    sdk::Blob {
        contract_name: contract_name.clone().into(),
        data: sdk::BlobData(
            bincode::encode_to_vec(
                TicketAppAction::BuyTicket {},
                bincode::config::standard(),
            )
            .expect("Failed to encode Buy Ticket action"),
        ),
    },
];

let blob_tx = BlobTransaction {
    identity: Identity(cli.user.clone()),
    blobs: blobs.clone(),
};

// Send the blob transaction
let blob_tx_hash = client.send_tx_blob(&blob_tx).await.unwrap();
println!("✅ Blob tx sent. Tx hash: {}", blob_tx_hash);
```

##### Prove the ticket transfer

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
    identity: cli.user.clone().into(),
    tx_hash: "".into(),
    private_blob: sdk::BlobData(vec![]),
    blobs: blobs.clone(),
    index: sdk::BlobIndex(1),
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

Check the full annotated code in [our GitHub example](https://github.com/Hyle-org/examples/blob/feat/ticket-app/ticket-app/host/src/main.rs).
