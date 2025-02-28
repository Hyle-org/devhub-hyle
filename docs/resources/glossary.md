# Glossary

|              Term              |                                                            Definition                                                           | Related concept page |
|:------------------------------:|:-------------------------------------------------------------------------------:|:--------------:
| **blob**                       | A piece of provable information that is sent to Hylé.                                                                           | [Smart contracts](../concepts/smart-contracts.md) |
| **blob transaction**           | A transaction including a provable *blob*, used for sequencing.       | [Pipelined proving](../concepts/proof-composability.md) |
| **cross-contract composition** | The ability to use and verify a contract's proofs in other contracts.  | [Proof composition](../concepts/proof-composability.md) |
| **operation**                  | Something that happens on an *unchained app*. An operation includes two *transactions*: a *blob transaction* and a *proof transaction*. | [Transactions](../concepts/transaction.md) |
| **proof composition**          | The process of combining multiple zero-knowledge proofs into a single proof, enabling efficient verification and interoperability across different proving systems.  | [Proof composition](../concepts/proof-composability.md) |
| **proof transaction**          | A *transaction* including a proof of a previously-submitted *blob*, used for verification and settlement.   | [Transactions](../concepts/transaction.md) |
| **proof verification**         | The act by which Hylé verifies submitted proofs before settling them onchain.                               | [Transactions](../concepts/transaction.md) |
| **timeout**                    | A time window after which, if no *proof transaction* has been submitted, an *operation* fails.    | [Pipelined proving](../concepts/proof-composability.md) |
| **transaction**                | A part of an *operation* that gets sent to Hylé. There are two types of transactions: *blob transactions* and *proof transactions*.   | [Transactions](../concepts/transaction.md) |