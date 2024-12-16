# Proof composition and cross-contract calls

Most applications require multiple proofs for their transactions. These proofs need to reference one another.

To understand the concept of proof composability on Hylé, we recommend you [read this blog post](https://blog.hyle.eu/proof-composability-on-hyle/). This guide focuses on demonstrating how to use proof composition in your code.

## What is proof composition?

Proof composition is what happens when two transactions depend on each other's proofs. Proof composability is the fact that Hylé allows you to manage this easily.

Most zero-knowledge systems deal with cross-contract calls by enforcing recursive proof verification:

- Program A verifies proof of correct execution of Program B
- Program B verifies proof of correct execution of Program A.

Hylé allows you to assume, when creating Program A, that Program B has been successfully executed. If you batch both transactions in the same blob, we verify both natively outside of the contract; the whole blob fails if one transaction fails.

Read more [on our blog](https://blog.hyle.eu/proof-composability-on-hyle/).

## Writing a cross-contract call

Your program does not need to verify the execution of another program directly. Instead, it uses a representation of the external execution.

This representation consists of:

- the app
- the function
- the function's parameters
- a claim on the results.

Claims can look like this: `MoneyApp::transfer(10, A, B) == true` or `TicketApp::get(A) == ticket`.

Follow these steps:

1. **Inject claims**: add all the claims as inputs to the transaction.
1. **Index claims**: provide an index to tell the contract where to locate its input.
1. **Assert claims**: use the claim list to validate the required conditions for the transaction.

## How Hylé settles multiple proofs

When you submit multiple proofs in a single transaction to Hylé:

- Proofs are verified simultaneously. The total proving time is determined by the slowest proof; proving times do not compound.
- All proofs are verified separately, but in a single transaction. If one proof verification fails, then the entire transaction fails.
