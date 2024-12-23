# Proof composition and cross-contract calls

<!-- Réécrire avec un exemple -->

To understand the concept of proof composability on Hylé, we recommend you [read this blog post](https://blog.hyle.eu/proof-composability-on-hyle/). This page focuses on demonstrating how to use proof composition in your code.

## What is proof composition?

**Proof composition** happens when two contracts depend on each other. **Proof composability** is the fact that Hylé allows you to manage this situation while keeping their proofs independent.

Most zero-knowledge systems deal with cross-contract calls by enforcing recursive proof verification:

- Program A verifies proof of correct execution of Program B;
- Program B verifies proof of correct execution of Program A.

<!-- Rewrite section -->
Hylé allows you to assume, in Program A, that Program B has been successfully executed, by verifying that claim. If you batch both blobs in the same operation, we verify both natively outside of the contract; the whole operation fails if one proof fails to verify.

Read more [on our blog](https://blog.hyle.eu/proof-composability-on-hyle/).

## Writing a cross-contract call

Your program does not need to verify the execution of another program directly.

Instead, it uses a representation of the called contracts, which looks like this: `MoneyApp::transfer(10, A, B) == true` or `TicketApp::get(A) == ticket`.

This representation consists of:

- the app
- the function
- the function's parameters
- a claim on the results.

<!-- TODO: replace list with an example -->

Follow these steps:

1. **Inject claims**: add all the claims as inputs to the blob.
1. **Index claims**: provide an index to tell the contract where to locate its input.
1. **Assert claims**: use the claim list to validate the required conditions for the blob.

## How Hylé settles multiple proofs

When you submit multiple proofs to Hylé:

- Proof generation can be parallelized: proving times do not compound since proofs do not depend on each other.
- Proof verification is asynchronous thanks to [pipelined proving](./pipelined-proving.md). As soon as one proof is ready, it can be verified on Hylé, even if the other proofs aren't ready yet.
- Once all proofs related to the transaction are verified, the transaction is settled on Hylé. If one proof verification fails, then the entire transaction fails.

Read more [on our blog](https://blog.hyle.eu/proof-composability-on-hyle/).
