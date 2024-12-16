# What does a smart contract look like?

Hylé is a fully programmable blockchain. We only store the minimal amount of data required to validate smart contract proofs, so our smart contracts have very little information.

Hylé smart contracts include:

- **Name**: the unique identifier for your contract
- **Verifier**: the proof system (e.g. "risc0" or "gnark-groth16-te-BN254")
- **Program ID**: the unique identifier for your program in that proof system
- **State digest**: current state commitment of the contract

## Name

The name of your contract, which must be unique.

## Verifier and program identifier

Smart contracts in Hylé are identified by a zero-knowledge proof scheme and a matching identifier. This tuple is required to verify proofs.

| Proving scheme | Verifier | Program ID                                        |
|----------------|----------|---------------------------------------------------|
| Risc Zero      | risc0    | Image ID without a prefix. ex. 0x123 becomes 123. |
| SP1            | sp1      |                                                   |

<!--- **Cairo**: Cairo smart contracts will be identified by their Class Hash in the future.
- **Noir**: Noir smart contracts are identified by they verifying key.
- **Groth16**: Groth16 programs require a trusted ceremony. As such, their identifier is the verifying key corresponding to the matching private key, which will be unique for each program & ceremony.-->

## State commitment

The state commitment is the minimal amount of data required to attest to the full state of the smart contract.

Some examples of valid state commitments:

- The full state, for a sufficiently small program (e.g. the [Collatz example](../examples/collatz-example-in-depth.md), or a smart-contract with a nonce)
- A merkle root of the state, for larger programs
- A hash of the full state
