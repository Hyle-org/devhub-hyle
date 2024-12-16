# Pipelined proving

## A smart contract is a rollup

Hylé ensures both privacy and scalability by verifying only the state transitions of smart contracts.

Provable applications face several challenges:

- **Proof generation latency**: proof generation can be slow, especially on less powerful devices.
- **Timekeeping**: proofs require accurate time information, but users can't predict when their transaction will be sequenced.
- **Parallelization**: proofs must include valid state transitions, but multiple transactions can accidentally reference the same base state.

We solve these issues by splitting sequencing from settlement.

## Blob-transaction vs. Proof-transaction

Hylé splits operations into two transactions:

1. **Blob-transaction**: claims that a state has changed.
2. **Proof-transaction**: provides a proof for the claimed state change.

From Hylé’s perspective, the blob-transaction's content is irrelevant: it simply represents incoming information that your contract will process.

1. **Sequencing** happens when the blob transaction is received and included in a block. This step establishes a global order and timestamps for transactions.
1. **Settlement** happens when the corresponding proof transaction is verified and added to the block.

During settlement, unproved blob transactions linked to the contract are executed in their sequencing order.

## Unprovable transactions

Hylé introduces **timeouts** for blob transactions to ensure timely proof submissions.

Transactions without proofs within a specific duration, as well as transactions with invalid proofs, are rejected.
