# What does a smart contract look like?

Hylé is a fully programmable blockchain. We only store the minimal amount of data required to validate smart contract proofs, so our smart contracts have very little information.

Hylé smart contracts include:

- a name
- a program identifier
- a state commitment.

## Name

The name of your contract.

## Program Identifier

Smart contracts in Hylé are identified by a zero-knowledge proof scheme and a matching identifier. This tuple is required to verify proofs.

- **Cairo**: Cairo smart contracts will be identified by their Class Hash in the future.
- **Noir**: Noir smart contracts are identified by they verifying key.
- **Risc Zero**: Risc Zero smart contracts are identified by their `image ID`. Two identical programs will have identical image IDs.
- **Groth16**: Groth16 programs require a trusted ceremony. As such, their identifier is the verifying key corresponding to the matching private key, which will be unique for each program & ceremony.

## State Commitment

The state commitment is intended to be the minimal amount of data required to attest to the full state of the smart contract.  

Some example of such structures include:

- The full state, for a sufficiently small program (e.g. a fibonacci counter, or a smart-contract with a nonce)
- A merkle root of the state, for larger programs
- A hash of the full state could also be used