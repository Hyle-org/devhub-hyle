# Pipelined proving

## The problem: base state conflicts

Hylé ensures both privacy and scalability by verifying only the state transitions of smart contracts. This approach reduces computational overhead but introduces a critical issue for provable applications: base state conflicts.

Proof generation can be slow, especially on less powerful devices. An app with a lot of usage will see conflicting operations, where multiple transactions reference the same base state, waiting for the previous state change to be settled.

Since proof generation lags behind sequencing, users submitting transactions cannot be certain which state their operation will build upon, causing:

- **Proof generation latency**: the time spent generating proofs delays transaction finality.
- **Timekeeping uncertainty**: proofs require accurate timestamps, but users can't predict when their transaction will be sequenced.
- **Parallelization limits**: multiple transactions may reference the same base state, creating invalid proofs when one is settled before the other.

We solve these issues by splitting sequencing from settlement; an operation includes two transactions.

## Blob-transaction vs. Proof-transaction

To address base state conflicts, Hylé splits operations into two transactions:

1. **Blob-transaction**: outlines a state change for sequencing.
2. **Proof-transaction**: provides a proof of the state change for settlement.

From Hylé’s perspective, the blob-transaction's content does not matter: it simply represents incoming information that your contract will process. For a developer, **sequencing** provides you with a fixed order and timestamp before proving begins. Once the transactions are sequenced, the provers can easily know upon which state they should base their proof.

**Settlement** happens when the corresponding proof transaction is verified and added to a block. During settlement, unproven blob transactions linked to the contract are executed in their sequencing order.

![A graph with Alice, Bob, and the token state. On the middle line, there's a starting state. Alice sends her TX A blob, which updates the token's virtual state; a bit later, Bob sends a TX B blob which is sequenced. The updated state will now be used as the start state for the TX B proof, while Alice can prepare to send her TX A proof. This updates the token's state for TX A, then for TX B.](../../assets/img/pipelined-proving.jpg)

This separation solves all three issues shown above. The blob transaction immediately reserves a place in execution order, allowing proof generation to run without blocking other transactions. It provides an immutable timestamp, so provers know which base state to use when generating proofs and can parallelize actions.

## Unprovable transactions

Even with pipelined proving, the delay in proof generation and submission can delay transaction finality and create uncertainty when determining the initial state of subsequent transactions.

To remove this bottleneck, Hylé enforces timeouts for blob transactions.

Each blob transaction is assigned a specific time limit for the associated proof to be submitted and verified. If the proof is not successfully provided within this window, the transaction is rejected: it is ignored for state updates but remains recorded in the block.

The inclusion of the unproven transaction in the block ensures transparency, as the transaction data remains accessible.

Subsequent transactions can proceed without waiting indefinitely.
