# Pipelined proving

## The problem: base state conflicts

Hylé ensures both privacy and scalability by verifying only the state transitions of smart contracts.

However, provable applications usually run into an issue. Proof generation can be slow, especially on less powerful devices, and an app with a lot of usage will see conflicting operations, ie. operations that start with the same base state because the previous state change hasn't been settled yet.

This is linked to several challenges:

- **Proof generation latency**
- **Timekeeping**: proofs require accurate time information, but users can't predict when their transaction will be sequenced.
- **Parallelization**: proofs must include valid state transitions, but multiple transactions can accidentally reference the same base state.

We solve these issues by splitting sequencing from settlement; an operation includes two transactions.

## Blob-transaction vs. Proof-transaction

Hylé splits operations into two transactions:

1. **Blob-transaction**: outlines a state change for sequencing.
2. **Proof-transaction**: provides a proof for the claimed state change for settlement.

From Hylé’s perspective, the blob-transaction's content is not an issue: it simply represents incoming information that your contract will process.

1. **Sequencing** happens when the blob transaction is received and included in a block. This step establishes a global order and timestamps for transactions.
1. **Settlement** happens when the corresponding proof transaction is verified and added to a block.

During settlement, unproven blob transactions linked to the contract are executed in their sequencing order.

## Unproven transactions

Even with [pipelined proving](./pipelined-proving.md), the delay in proof generation and submission can delay transaction finality and create uncertainty when determining the initial state of subsequent transactions.

To remove this bottleneck, Hylé enforces **timeouts** for blob transactions.

Each blob transaction is assigned a specific time limit for the associated proof to be submitted and verified. If the proof is not successfully provided within this window, the transaction is rejected: it is ignored for state updates but remains recorded in the block.

The inclusion of the unproven transaction in the block ensures transparency, as the transaction data remains accessible.

Subsequent transactions can proceed without waiting indefinitely.
