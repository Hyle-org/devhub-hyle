# Proof composition with Ticket-App

Hylé's native proof verification allows for proof composition. To understand the concept better, we recommend you [read this blog post](https://blog.hyle.eu/proof-composability-on-hyle/).

This guide walks you through creating your first ticket transfer contract. With it, you will leverage proof composition to make a ticket-app and a [simple-token app](./your-first-smart-contract.md) interact.

Find the source code for both contracts here:

- [ticket-app](https://github.com/Hyle-org/examples/tree/feat/ticket-app/ticket-app)
- [simple-token](https://github.com/Hyle-org/examples/tree/feat/ticket-app/simple-token)

## Run the example

### Prerequisites

- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- For our example, [install RISC Zero](https://dev.risczero.com/api/zkvm/install).
- [Start a single-node devnet](./devnet.md). We recommend using [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) with `-e RISC0_DEV_MODE=1` for faster iterations during development.

This quickstart guide will take you through the following steps:

<!--Replace with workflow-->
- [Simple-identity preparation](#simple-identity-preparation): register an identity contract & two identities.
- [Simple-token preparation](#simple-token-preparation): register a token contract and faucet the users with this token.
- [Register the ticket-app contract](#register-ticket-app)
- [Buy a ticket on ticket-app](#buy-a-ticket)

### Simple-identity preparation

<!-- Write -->
To be added.

`bob.simple-identity`, which will be used extensively from now on, refers to bob's identity on the simple-identity contract. Check out our [Identity management](../general-doc/identity.md) and [custom identity contract](./custom-identity-contract.md) pages to know more.

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
cargo run -- -contract-name simple-token transfer faucet.simple-token bob.simple-identity 50
cargo run -- -contract-name simple-token transfer faucet.simple-token alice.simple-identity 10
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

cargo run -- --contract-name simple-token balance bob.simple-identity
cargo run -- --contract-name simple-token balance alice.simple-identity
```

### Using ticket-app

Now that *bob* has some tokens, let's buy him a ticket.

#### Register ticket-app

Register the ticket app by going to `./ticket-app` folder and running:

```bash
cargo run -- --contract-name ticket-app register simple-token 15
```

ticket-app sells a ticket for 15 simple-token.

#### Buy a ticket

Let's buy a ticket for *bob*:

```bash
cargo run -- --contract-name ticket-app --user bob.simple-identity buy-ticket
```

Let's try with *alice*:

```bash
cargo run -- --contract-name ticket-app --user alice.simple-identity buy-ticket
```

You will get an error while executing the TicketApp program: `Execution failed ! Program output: Insufficient balance`. This is because Alice has a balance of 10 and the ticket costs 15.

#### Check ticket and token balance

Check that *bob* has a ticket:

```bash
cargo run -- --contract-name ticket-app --user bob.simple-identity has-ticket
```

You can also check Bob's balance and see he now has 35 tokens.

## Development mode

We recommend activating [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) during your early development phase for faster iteration upon code changes with `-e RISC0_DEV_MODE=1`.

You may also want to get insights into the execution statistics of your project: add the environment variable `RUST_LOG="[executor]=info"` before running your project.

The full command to run your project in development mode while getting execution statistics is:

```bash
RUST_LOG="[executor]=info" RISC0_DEV_MODE=1 cargo run
```

## Behind-the-scenes

<!--Graph-->

### Step 1: Cross-app composition

`ticket-app` checks that there is a `simple-token` blob asserting that 15 simple-tokens have been removed from `bob.simple-identity`'s balance.

### Step 2: Send the blob transaction

ticket-app then sent a blob transaction to Hylé, including three blobs:

- the usual identity blob confirming that ticket-app is creating the transaction (see our [anatomy of a transaction](../general-doc/transaction.md))
- a ticket-app blob asserting that `bob.simple-identity` now has a ticket
- the simple-token blob above, asserting that `bob.simple-identity` sent 15 tokens to `ticket-app`

### Step 3: Prove the blobs

Thanks to [pipelined proving](../general-doc/pipelined-proving.md), Hylé sequences this transaction; ticket-app can take care of generating ZK proofs of each of the blobs and submitting them in due time.

### Step 4: Settlement

Hylé verifies the submitted proofs. If they're all valid, the simple-token balance and ticket-app ticket balance are updated simultaneously at transaction settlement. If one of the proofs fails (ie. if the simple-token transfer fails or if the ticket transfer fails), the whole transaction fails and neither state is updated.

Read more about this example on our blog.

## Code snippets

Find the full annotated code in [our examples repository](https://github.com/Hyle-org/examples/blob/main/ticket-app/host/src/main.rs).

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
