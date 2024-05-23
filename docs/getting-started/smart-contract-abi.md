# Smart Contract ABI

Writing smart contracts on Hylé is both similar and quite different from other blockchains because of our focus on verifying ZK proofs.

Depending on the type of ZK proof circuits you use, there are some superficial differences, but the overall idea is that all inputs are known at proof generation time. This includes things which are unusual, such as the origin of the transaction (`tx.origin` in Ethereum) and the block number.

The Hylé protocol enforces several invariants on transactions to make sure everything is secure. For this reason, we must specify some of the data within a zero-knowledge proof.

This page uses the Rust structures to demonstrate, but you can use the following repos for other languages:
- Rust example: https://github.com/Hyle-org/collatz-conjecture
- Gnark / Groth16 example: https://github.com/Hyle-org/groth16-example

## Overview

Here is the rust struct specifying the output of a Hylé smart contract:
```rust
pub struct HyleOutput<T> {
    pub version: u32,
    pub initial_state: Vec<u8>,
    pub next_state: Vec<u8>,
    pub origin: String,
    pub caller: String,
    pub block_number: u64,
    pub block_time: u64,
    pub tx_hash: Vec<u8>,
    pub program_outputs: T
}
```

The `version` field should currently be set to 1.

<!-- Inclure diagramme sur le flow d'une preuve ici -->

### Initial State and Next State

Blockchains transactions are fundamentally state transitions. These are the fields to handle that securely in the protocol.  
The `initial_state` field should match the state digest of the contract before the transaction. This could be several things, such as:
- the hash of the previous state
- the Merkle root of the previous state tree
- the state itself if it's small enough

The protocol enforces that this `initial_state` matches the `state_digest` it knows of onchain. Otherwise, the state transition is invalid.

The `next_state` field, of course, represents the new onchain `state_digest` after the transaction.

Smart contracts are responsible for the actual structure of this field. In the future, fees will in part depend on the size of the `state_digest`, so it is encouraged to keep this small.

### Origin

The `origin` field is the identifier of the person who initiated the transaction.  
Unlike in all other blockchains, Hylé does not have a native signature type. Instead, Hylé uses the `origin` field of the first proof to determine origin.
To make this safe, the field is composite, and its end is the name of the contract the proof was generated for.

Hylé could for example support Ethereum EOAs, if a smart contract is registered onchain to verify them. The `origin` would then look something like `0x1234...5678.eth_eoa`, where `eth_eoa` is the name of the contract, and the first part matches a regular Ethereum address.

This gives us massive flexibility in the future to support any kind of identity verification, including WebAuthn, social media accounts, etc.

NB: for now, any subsequent proof in a TX must declare the same `origin` or an empty one, or the transaction will be rejected.

### Caller

The `caller` field is the identifier of the contract that called the current contract, aka the proof before the current one in the transaction.
This can be used to do Ethereum-style contract calls.

### Block Number and Time

These fields are currently not enforced. Because they must be known at proof generation time, you would need to predict when the proof will be included in a block.  
This is of course quite difficult, so we are working on a design to support this in the future.

Note that smart contracts that do not depend on the block number or time can still be written and deployed safely by outputting 0.

### TX Hash

The `tx_hash` field is intended to hash transaction data, preventing replay attacks and providing a means for contracts to access this information.
The field is currently completely unspecified and isn't validated by the protocol.


### Other program-specific outputs

Smart contracts can provide other outputs as part of the proof they generate. This can be used for a variety of purposes, but mostly serves to provide Data Availability. See [Data Availability](../about/data-availability.md) for more information.

## Events ?

Hylé currently does not ship native events, but they should be implemented in the close future.
