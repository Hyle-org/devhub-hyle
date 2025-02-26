# Smart contracts

Hylé is a fully programmable blockchain designed for efficient data storage. Hylé only keeps the essential information needed to validate smart contract proofs, ensuring that smart contracts are lightweight and performant.

Unlike [traditional blockchains](./hyle-vs-vintage-blockchains.md), which store all smart contract data onchain, Hylé separates offchain execution data from onchain state data. The onchain data can be retrieved through our ABI.

## Onchain data about smart contracts

Hylé smart contracts store the following data onchain:

- **Name**: the unique identifier for your contract
- **Verifier**: the proof system (e.g. "risc0" or "gnark-groth16-te-BN254")
- **Program ID**: the unique identifier for your program in that proof system
- **State digest**: current state commitment of the contract

### Explanation of the contract fields

#### Name

The contract name must be unique.

#### Verifier and program identifier

Smart contracts on Hylé rely on a pairing of a zero-knowledge proof scheme (verifier) and a program identifier. Together, these components validate contract proofs.

We've written templates for some of our supported programs. Clone them to get started with smart contract writing.

| Proving scheme | Verifier | Program ID | Template                                       |
|----------------|----------|---------------------------------------------------|---|
| Noir           | noir     | Verification key.                                 |   - |
| Risc Zero      | risc0    | Image ID without a prefix. ex. 0x123 becomes 123. | [Template](https://github.com/Hyle-org/risc0-template)  |
| SP1            | sp1      | Verification key.                                 |   - |

<!--- **Cairo**: Cairo smart contracts will be identified by their Class Hash in the future.
- **Groth16**: Groth16 programs require a trusted ceremony. As such, their identifier is the verifying key corresponding to the matching private key, which will be unique for each program & ceremony.-->

#### State digest

The state digest represents the contract's current state commitment. It allows Hylé to guarantee its integrity. It can take any form as long as it fulfills this purpose.

The state digest can be expressed as a hash or even a serialization of the state if it's small enough.

## Smart contract ABI

All inputs in Hylé smart contracts must be known at proof generation time. This includes elements like the `tx_hash` which are typically available only at execution time on other blockchains.

Here is the Rust structure specifying the output of a Hylé smart contract:

```rust
pub struct HyleOutput {
    pub version: u32,
    pub initial_state: StateDigest,
    pub next_state: StateDigest,
    pub identity: Identity,
    pub index: BlobIndex,
    pub blobs: Vec<u8>,
    pub tx_hash: TxHash,
    pub success: bool,
    pub tx_ctx: Option<TxContext>, // optional
    pub registered_contracts: Vec<RegisterContractEffect>,
    pub program_outputs: Vec<u8>, 
}
```

### Version

For now, `version` should always be set to 1.

### Initial state and next state

These fields define state transitions.

- `initial_state`: must match the onchain `state_digest` before the transaction. If they don't match, the state transition is invalid.
- `next_state`: Represents the new onchain `state_digest` after the transaction.

Future fees may depend on `state_digest` size, so keep it minimal.

### Identity

!!! info
    Read [our identity documentation](./identity.md) for details.

Identity consists of:

1. An address;
1. The name of the contract that the proof was generated for.

!!! example
    A contract verifying Ethereum EOAs might have an identity like `0x1234...5678.eth_eoa` where the first part matches a regular Ethereum address and `eth_eoa` is the name of the contract.

### Blob index and blobs

Each blob transaction includes multiple blobs:

- `index` uniquely identifies a blob within a transaction.
- `blobs` is a list of all blobs included in the transaction.

### TX Hash

`tx_hash` is a hash of transaction data.

The protocol does not validate this field and `tx_hash` may be deprecated in later versions.

### Success

This boolean field indicates whether the proof is for a successful or failed transactions. It can be used to prove that a transaction is invalid.

Use case example: [Vibe Check](https://github.com/Hyle-org/vibe-check/blob/main/cairo-reco-smile/src/lib.cairo#L297).

### Transaction context

This field is optional. If left empty, it will not be validated by Hylé or usable by the program.

### Registered contracts

Stores the effects of registered contracts.

### Other program-specific outputs

Smart contracts can generate additional outputs as proof data. These outputs ensure data availability.

## Events

Hylé does not use traditional events. Instead, it relies on blobs, which serve as containers for offchain data.
