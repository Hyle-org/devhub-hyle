# Proof composition and cross-contract calls

Most applications require multiple pieces of information, and proofs are the condition for settling the actions in their transaction. These actions are interdependent, which means proofs have to reference each other.

To better understand the concept of proof composability on Hylé, we recommend you [read this blog post](https://blog.hyle.eu/proof-composability-on-hyle/). This page aims at explaining what proof composition looks like in your code.

## What is proof composition?

Proof composition is what happens when two transactions depend on each other's proofs. Proof composability is the fact that Hylé allows you to manage this easily.

Most zero-knowledge systems deal with cross-contract calls by enforcing recursive proof verification: Program A verifies proof of correct execution of Program B, and Program B verifies proof of correct execution of Program A.

Hylé allows you to assume, when creating Program A, that Program B has been successfully executed. If you batch both transactions in the same blob, we verify both natively outside of the contract; the whole blob fails if one transaction fails.

## Writing a cross-contract call

Your program does not need to include a verification of Program B's successful execution. It only needs a representation of that execution.

This representation consists of:

- the app
- the function
- its parameters
- a claim on the results.

Claims can look like this, for instance: `MoneyApp::transfer(10, A, B) == true` or `TicketApp::get(A) == ticket`.

Follow these steps:

1. Inject the whole list of claims as inputs;
1. Add an index to tell the contract where to locate its input;
1. Use the claim list to assert whatever you need in the transaction about other contract calls.

## How Hylé settles multiple proofs

Proofs in a single transaction are sent to Hylé atomically and simultaneously. If one proof verification fails, the transaction fails; if all proof verifications succeed, the transaction is settled onchain.

They can be verified **simultaneously** despite their mutual dependencies and achieve a proving time equal to the slowest proving time of all transaction contracts rather than compounding them.
