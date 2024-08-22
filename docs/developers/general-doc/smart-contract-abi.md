# Smart Contract ABI

Hylé focuses on verifying zk-proofs. Because of this, writing smart contracts on Hylé has some specificities, with other elements being the same as with most other blockchains.

Depending on the type of zk-proof circuits you use, there are some superficial differences, but the overall idea is that **all inputs are known at proof generation time**. This includes unusual elements such as the origin of the transaction (`tx.origin` in Ethereum) and the block number.

The Hylé protocol enforces several invariants on transactions to maximize security. For this reason, we must specify some of the data within a zero-knowledge proof.

This page uses the Rust structures to demonstrate, but you can use the following repos for other languages:

- Rust example: https://github.com/Hyle-org/collatz-conjecture
- Gnark / Groth16 example (currently outdated): https://github.com/Hyle-org/groth16-example

## Overview

Here is the rust struct specifying the output of a Hylé smart contract:

```rust
pub struct HyleOutput<T> {
    pub version: u32,
    pub initial_state: Vec<u8>,
    pub next_state: Vec<u8>,
    pub identity: String,
    pub tx_hash: Vec<u8>,
    pub payload_hash: Vec<u8>,
    pub success: bool,
    pub program_outputs: T
}
```

The `version` field should currently be set to 1.

<!-- Inclure diagramme sur le flow d'une preuve ici -->

### Initial State and Next State

Blockchains transactions are fundamentally **state transitions**. These fields handle the state transitions securely in the protocol.

The `initial_state` field should match the state digest of the contract before the transaction. This could consist of several things, such as:

- the hash of the previous state
- the Merkle root of the previous state tree
- the state itself if it's small enough

The protocol enforces that this `initial_state` matches the onchain `state_digest` it knows. Otherwise, the state transition is invalid.

The `next_state` field represents the new onchain `state_digest` after the transaction.

Smart contracts can adapt the actual structure of this field. In the future, fees will depend on the size of the `state_digest` (among other criteria), so we encourage you to keep it small.

### Identity

The `identity` field is the identifier of the person who initiated the transaction.

Unlike other blockchains, Hylé does not have a native signature type. Instead, Hylé uses the `identity` field of the first proof to identify the TX sender.
To ensure security, the field is composite and ends with the name of the contract that the proof was generated for.

Hylé could for example support Ethereum EOAs, if a smart contract is registered onchain to verify them. The `identity` would then look something like `0x1234...5678.eth_eoa`, where `eth_eoa` is the name of the contract, and the first part matches a regular Ethereum address.

This gives us massive flexibility in the future to support any kind of identity verification, including WebAuthn, social media accounts, etc.

!!! note
For now, any subsequent proof in a TX must declare the same `identity` or an empty one, or the transaction will be rejected.

### TX Hash

The `tx_hash` field is intended to hash transaction data, preventing replay attacks and providing a means for contracts to access this information.

The field is currently completely unspecified and isn't validated by the protocol.

### Payload Hash

This should match the hash of the payload that was sent to the network initially. Currently we use pedersen hashing for Cairo, no hashing for Risc0. Others are unimplemented.
This is very WIP (as of August 2024) and will change soon.

### Success

This is a boolean - whether the proof is for a succesful proof or a failure case. It can be useful to prove that a transaction is invalid. See our example in [Vibe Check](https://github.com/Hyle-org/vibe-check/blob/main/cairo-reco-smile/src/lib.cairo#L297).

### Other program-specific outputs

Smart contracts can provide other outputs as part of the proof they generate.

This can be used for a variety of purposes, but mostly serves to provide Data Availability. See [Data Availability](./data-availability.md) for more information.

## Events

Hylé does not currently ship native events. We are looking into implementing them in the near future.
