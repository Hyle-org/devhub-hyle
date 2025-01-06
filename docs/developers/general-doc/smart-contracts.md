# Smart contracts

Hylé is a fully programmable blockchain that optimizes data storage by keeping only the essential information needed to validate smart contract proofs. This design ensures that Hylé smart contracts are lightweight and efficient.

Where traditional blockchains keep all smart contract information onchain, Hylé splits offchain data (your contract's execution) and onchain data, which is retrieved through our ABI.

## Onchain data about smart contracts

Hylé smart contracts' onchain data consists of:

- **Name**: the unique identifier for your contract
- **Verifier**: the proof system (e.g. "risc0" or "gnark-groth16-te-BN254")
- **Program ID**: the unique identifier for your program in that proof system
- **State digest**: current state commitment of the contract

### Explanation of the contract fields

#### Name

The name of your contract must be unique.

#### Verifier and program identifier

Smart contracts on Hylé rely on a pairing of a zero-knowledge proof scheme (verifier) and a program identifier. Together, these components validate contract proofs.

| Proving scheme | Verifier | Program ID                                        |
|----------------|----------|---------------------------------------------------|
| Risc Zero      | risc0    | Image ID without a prefix. ex. 0x123 becomes 123. |
| SP1            | sp1      | Verification key from the SP1 contract            |

<!--- **Cairo**: Cairo smart contracts will be identified by their Class Hash in the future.
- **Noir**: Noir smart contracts are identified by they verifying key.
- **Groth16**: Groth16 programs require a trusted ceremony. As such, their identifier is the verifying key corresponding to the matching private key, which will be unique for each program & ceremony.-->

#### State digest

The state digest is a minimal yet comprehensive representation of the contract's current state. It serves as the basis for verifying the integrity of the contract's data.

Some examples of valid state commitments:

- The full state, for a sufficiently small program (e.g. the [Collatz example](../examples/collatz-example-in-depth.md), or a smart-contract with a nonce)
- A merkle root of the state, for larger programs
- A hash of the full state

## Smart contract ABI

All inputs in Hylé smart contracts must be known at proof generation time. This includes elements that would be known at execution time on other blockchains, such as the origin of the transaction (tx.origin) and the block number.

Here is the Rust structure specifying the output of a Hylé smart contract:

```rust
pub struct HyleOutput {
    pub version: u32,
    pub initial_state: StateDigest,
    pub next_state: StateDigest,
    pub identity: Identity,
    pub tx_hash: TxHash,
    pub index: BlobIndex,
    pub blobs: Vec<u8>,
    pub success: bool,
    pub program_outputs: Vec<u8>,
}
```

### Explanation of the ABI fields

#### Version

For now, `version` should always be set to 1.

#### Initial state and next state

Blockchains transactions are fundamentally state transitions. These fields handle state changes securely.

- `initial_state`: Matches the onchain `state_digest` before the transaction. The `initial_state` must match the onchain `state_digest`. Otherwise, the state transition is invalid.
- `next_state`: Represents the new onchain `state_digest` after the transaction.

Smart contracts can adapt the actual structure of this field. In the future, fees will depend in part on the size of the `state_digest`, so we encourage you to keep it small.

#### Identity

The `identity` field identifies the person who initiates a transaction.

Hylé does not have a native signature type. Instead, it uses the `identity` field of the first proof in the transaction to identify the sender. This allows you to use any kind of identity verification.

The identity is in two parts:

1. An address;
1. The name of the contract that the proof was generate for.

For example, if a smart contract was registered onchain to verify Ethereum EOAs, the `identity` for them would look like `0x1234...5678.eth_eoa` where `eth_eoa` is the name of the contract and the first part matches a regular Ethereum address.

**Note**: All proofs in a transaction must declare the same identity as the first transaction or an empty identity.

#### TX Hash

The `tx_hash` field hashes transaction data, preventing replay attacks and providing a means for contracts to access this information.

The field is not validated by the protocol.

#### Blob index and blobs

Since a blob transaction can include several blobs, the design includes:

- `pub index: BlobIndex`: uniquely identifies a specific blob within a transaction.
- `pub blobs: Vec<u8>`: all blobs included in the transaction.

#### Success

This boolean field indicates whether the proof is for a successful transaction or a failure. It can be useful to prove that a transaction is invalid.

Use case example: [Vibe Check](https://github.com/Hyle-org/vibe-check/blob/main/cairo-reco-smile/src/lib.cairo#L297).

#### Other program-specific outputs

Smart contracts can provide additional outputs as part of the proof they generate.

These outputs mostly serve to provide data availability.

## Events

Hylé does not include events. The protocol replaces traditional event systems with blobs, which act as containers for offchain data.
