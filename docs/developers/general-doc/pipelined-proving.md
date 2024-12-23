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
1. **Settlement** happens when the corresponding proof transaction is verified and added to the block.

During settlement, proved blob transactions linked to the contract are executed in their sequencing order.

![A graph with Alice, Bob, and the token state. On the middle line, there's a starting state. Alice sends her TX A blob, which updates the token's virtual state; a bit later, Bob sends a TX B blob which is sequenced. The updated state will now be used as the start state for the TX B proof, while Alice can prepare to send her TX A proof. This updates the token's state for TX A, then for TX B.](../../assets/img/pipelined-proving.jpg)

## Unprovable transactions

Hylé introduces **timeouts** for blob transactions to ensure timely proof submissions.

Transactions without proofs within a specific duration, as well as transactions with invalid proofs, are rejected.
