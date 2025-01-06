# Identity management

## When to use identity contracts on Hylé

On Hylé, any smart contract can be a proof of identity: you can register your favorite identity source as a smart contract and use it to identify accounts. Hylé also ships [a native `hydentity` contract](https://github.com/Hyle-org/hyle/tree/main/contracts/hydentity) for simplicity.

This guide will walk you through creating and deploying your first simple identity contract using Hylé's tools and infrastructure and Risc0. We'll use [our simple identity example](https://github.com/Hyle-org/examples/tree/simple_erc20/simple-identity) as the basis for this tutorial.

For an in-depth understanding of smart contracts, check out our [identity management documentation](../general-doc/identity.md).

## Example

### Prerequisites

- [Install Rust](https://www.rust-lang.org/tools/install) (you'll need `rustup` and Cargo).
- For our example, [install RISC Zero](https://dev.risczero.com/api/zkvm/install).
- [Start a single-node devnet](./devnet.md). We recommend using [dev-mode](https://dev.risczero.com/api/generating-proofs/dev-mode) with `-e RISC0_DEV_MODE=1` for faster iterations during development.

### Build and register the contract

To build all methods and register the smart contract on the local node [from the source](https://github.com/Hyle-org/examples/blob/simple_erc20/simple-token/host/src/main.rs), run:

<!--
```bash
cargo run -- register 1000
```

The expected output is `📝 Registering new contract simple_token`.
-->

### Verify identity

<!--
To transfer 2 tokens from `faucet` to `Bob`:

```bash
cargo run -- transfer faucet.simple_token bob.simple_token 2
```
-->

This command will:

1. Send a blob transaction to verify `alice`'s identity.
2. Generate a ZK proof of that transfer.
3. Send the proof to the devnet.

### Verify settled state

Upon reception of the proof, the node will:

1. Verify the proof
1. Settle the blob transaction
1. Update the contract's state

<!--
The node's logs will display:

```bash
INFO hyle::data_availability::node_state::verifiers: ✅ Risc0 proof verified.
INFO hyle::data_availability::node_state::verifiers: 🔎 Program outputs: Transferred 2 to bob.simple_token
```

And on the following slot:

```bash
INFO hyle::data_availability::node_state: Settle tx TxHash("[..]")
```
-->

!!! note
    Please contact us directly to know more about identity management on Hylé. We are aiming to publish implementation instructions in January 2025.

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

<!--

Register + login : deux fonctions. Globalement : tu fais ton contrat comme tu veux, mais le plus simple c'est register + verify.
-->
