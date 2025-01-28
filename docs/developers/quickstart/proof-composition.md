# Proof composition with Ticket App

Hylé's native proof verification allows for proof composition. To understand the concept better, we recommend you [read this blog post](https://blog.hyle.eu/proof-composability-on-hyle/).

This guide walks you through creating your first ticket transfer contract. With it, you will leverage proof composition to make a Ticket App (with its corresponding contract `ticket-app`) and a [simple-token app](./your-first-smart-contract.md) interact.

Find the source code for all contracts here:

- [ticket-app](https://github.com/Hyle-org/examples/tree/feat/ticket-app/ticket-app)
- [simple-identity](https://github.com/Hyle-org/examples/tree/main/simple-identity)
- [simple-token](https://github.com/Hyle-org/examples/tree/feat/ticket-app/simple-token)

## How this example works

### Step 1: Create the blob transaction

The Ticket App backend creates and sends a blob transaction to Hylé, including three blobs:

- an *identity blob* (see our [custom identity contract quickstart](./custom-identity-contract.md)) confirming that Bob (`bob.id`) is initiating the transaction;
- a *simple-token blob* performing a transfer of 15 simple-tokens taken from `bob.id`'s balance;
- a *ticket-app blob* sending `bob.id` a ticket if conditions are met.

Once the blob is sent, it is sequenced on Hylé, without being processed. [Read more about pipelined proving.](../general-doc/pipelined-proving.md)

### Step 2: Prove the blobs

The Ticket App backend can now generate ZK proofs of each of the blobs.

During this time, the code of the `ticket-app` contract is executed. During execution, the `ticket-app` smart contract checks that there is a `simple-token` blob performing a transfer of 15 simple-tokens taken from `bob.id`'s balance to the `ticket-app` contract.

Check out what the [source code](https://github.com/Hyle-org/examples/blob/492501ebe6caad8a0fbe3f286f0f51f0ddca537c/ticket-app/contract/src/lib.rs#L44-L66) looks like.

At this step, `ticket-app` verifies that the transfer blob exists, but cannot verify that Bob has enough tokens in his balance to pay for the ticket. It is already, however, a sufficient condition for `ticket-app`, as the contract won't be settled onchain if the token transfer fails. This check will be performed by Hylé in Step 3.

### Step 3: Settlement

Hylé verifies the submitted proofs:

- identity blob: if this fails, it means `bob.id` has not initiated the transaction.
- simple-token blob: if this fails, it means `bob.id` did not pay for his ticket.
- ticket-app blob: if this fails, it means `bob.id` has not received the ticket.

If all proofs are valid, the simple-token balance and ticket-app ticket balance are updated simultaneously at transaction settlement: `bob.id` sends 15 simple-tokens and gains one ticket.

If any of the proofs fails, the whole transaction fails and neither state is updated: `bob.id`'s token balance does not change and still has no ticket.

In our example below, we're giving only 10 tokens to `alice.id`: because she can't perform the token transfer due to her low balance, the entire transaction fails.

## Run the example

!!! warning
    Our examples work on Hylé v0.7.2. Subsequent versions introduce breaking changes which have not yet been reflected in our examples.

### Prerequisites

- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- For our example, [install RISC Zero](https://dev.risczero.com/api/zkvm/install).
- [Start a single-node devnet](./devnet.md).

This quickstart guide will take you through the following steps:

- [Simple-identity preparation](#simple-identity-preparation): register an identity contract & two identities.
- [Simple-token preparation](#simple-token-preparation): register a token contract and faucet the users with this token.
- [Register the ticket-app contract](#register-ticket-app)
- [Buy a ticket on ticket-app](#buy-a-ticket)

### Simple-identity preparation

Let's start with registering an identity contract and two identities.

Go to the `./simple-identity` folder and run:

```sh
cargo run -- --contract-name id register-contract
```

Now we have an identity contract called `id`. We can use it to declare our users:

```sh
cargo run -- --contract-name id register-identity bob.id pass
cargo run -- --contract-name id register-identity alice.id pass
```

We now have two users on the id contract: Alice and Bob, both of whom use the password `pass`.

Let's verify it quickly with:

```sh
cargo run -- --contract-name id verify bob.id pass 0
```

0 is a nonce: every time we verify successfully bob's identity, it increments. Now if we want to verify it again, we should use 1 as nonce.

We now do the same for alice:

```sh
cargo run -- --contract-name id verify alice.id pass 0
```

`bob.id`, which will be used extensively from now on, refers to bob's identity on the simple-identity contract. Check out our [Identity management](../general-doc/identity.md) and [custom identity contract](./custom-identity-contract.md) pages to know more.

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
cargo run -- -contract-name simple-token transfer faucet.simple-token bob.id 50
cargo run -- -contract-name simple-token transfer faucet.simple-token alice.id 10
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

cargo run -- --contract-name simple-token balance bob.id
cargo run -- --contract-name simple-token balance alice.id
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
cargo run -- --contract-name ticket-app --user bob.id buy-ticket
```

Let's try with *alice*:

```bash
cargo run -- --contract-name ticket-app --user alice.id buy-ticket
```

You will get an error while executing the TicketApp program: `Execution failed ! Program output: Insufficient balance`. This is because Alice has a balance of 10 and the ticket costs 15.

#### Check ticket and token balance

Check that *bob* has a ticket:

```bash
cargo run -- --contract-name ticket-app --user bob.id has-ticket
```

You can also check Bob's balance and see he now has 35 tokens.