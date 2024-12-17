# Smart contracts on Hylé

Hylé is a fully programmable blockchain that optimizes data storage by keeping only the essential information needed to validate smart contract proofs. This design ensures that Hylé smart contracts are lightweight and efficient.

Hylé smart contracts include:

- **Name**: the unique identifier for your contract
- **Verifier**: the proof system (e.g. "risc0" or "gnark-groth16-te-BN254")
- **Program ID**: the unique identifier for your program in that proof system
- **State digest**: current state commitment of the contract

Depending on the type of zk-proof circuits you use, there are some superficial differences, but the overall idea is that all inputs are known at proof generation time.

This page uses the Rust structures to demonstrate, but you can use the following repos for other languages:

- Rust example: https://github.com/Hyle-org/collatz-conjecture
- Gnark / Groth16 example (outdated): https://github.com/Hyle-org/groth16-example

## Name

The name of your contract must be unique.

## Verifier and program identifier

Smart contracts on Hylé rely on a pairing of a zero-knowledge proof scheme (verifier) and a program identifier. Together, these components validate contract proofs.

| Proving scheme | Verifier | Program ID                                        |
|----------------|----------|---------------------------------------------------|
| Risc Zero      | risc0    | Image ID without a prefix. ex. 0x123 becomes 123. |
| SP1            | sp1      |                                                   |

<!--- **Cairo**: Cairo smart contracts will be identified by their Class Hash in the future.
- **Noir**: Noir smart contracts are identified by they verifying key.
- **Groth16**: Groth16 programs require a trusted ceremony. As such, their identifier is the verifying key corresponding to the matching private key, which will be unique for each program & ceremony.-->

## State digest

The state digest is a minimal yet comprehensive representation of the contract's current state. It serves as the basis for verifying the integrity of the contract's data.

Some examples of valid state commitments:

- The full state, for a sufficiently small program (e.g. the [Collatz example](../examples/collatz-example-in-depth.md), or a smart-contract with a nonce)
- A merkle root of the state, for larger programs
- A hash of the full state
