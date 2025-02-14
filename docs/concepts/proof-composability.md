# Proof composition and cross-contract calls

To understand the concept of proof composability on Hylé, we recommend you [read this blog post](https://blog.hyle.eu/proof-composability-on-hyle/).

To understand proof composition in practice, check out [our quickstart example](..//quickstart/proof-composition.md).

## What is proof composition?

**Proof composition** happens when two contracts depend on each other. **Proof composability** is the fact that Hylé allows you to manage this situation while keeping their proofs independent.

Most zero-knowledge systems deal with cross-contract calls by enforcing recursive proof verification:

- Program A verifies proof of correct execution of Program B;
- Program B verifies proof of correct execution of Program A.

Hylé allows you to write Program A and add an input that says « this only applies if Program B is valid ». At settlement, with both contracts in the same proof transaction, it will verify both programs and the whole operation will fail if one proof fails to verify.

## Writing a cross-contract call

Your program does not need to verify the execution of another program directly.

Instead, it uses a representation of the called contracts, which looks like this: `MoneyApp::transfer(10, A, B) == true` or `TicketApp::get(A) == ticket`.

This representation consists of:

- the app
- the function
- the function's parameters
- a claim on the results.

In our quickstart example, [the source code looks like this](https://github.com/Hyle-org/examples/blob/492501ebe6caad8a0fbe3f286f0f51f0ddca537c/ticket-app/contract/src/lib.rs#L44-L66).

## How Hylé settles multiple proofs

When you submit multiple proofs to Hylé:

- Proof generation can be parallelized: proving times do not compound since proofs do not depend on each other.
- Proof verification is asynchronous thanks to [pipelined proving](./pipelined-proving.md). As soon as one proof is ready, it can be verified on Hylé, even if the other proofs aren't ready yet.
- Once all proofs related to the transaction are verified, the transaction is settled on Hylé. If one proof verification fails, then the entire transaction fails.

Read more [on our blog](https://blog.hyle.eu/proof-composability-on-hyle/).
