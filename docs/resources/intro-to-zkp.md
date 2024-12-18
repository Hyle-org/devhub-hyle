---
title: Understanding zero-knowledge proofs
---

Here are some resources on zero-knowledge proofs and how to generate them.

## When to use zero-knowledge proofs

There are three moments when ZK is the right tool for you:

- **Computing power imbalance** (which includes improved **scalability**): verify a result without running the resource-heavy computation.
- **Adversarial environment**: prove an outcome without sharing the trade secrets that got you to this outcome.
- **Anonymity**: reveal only necessary data without exposing personal or sensitive details.

## Tools and languages for zero-knowledge proofs

There are [many ZK languages](https://github.com/microbecode/zk-languages).

**DSLs** are languages that usually compile down to a specific circuit. They're good, but they have a steep learning curve.

**zkVMs** prove the correct execution of arbitrary code. Two popular types of zkVMs are Cairo and RISC-V. You can benchmark your Rust code and find the best zkVM for your needs with [the any-zkvm template](https://github.com/MatteoMer/any-zkvm).

Hylé aims to verify [as many proving schemes as possible](../developers/general-doc/supported-proving-schemes.md) eventually.

<!-- ## Choosing the best proof system for your needs -->

## Read more

- [awesome-zk](https://github.com/ventali/awesome-zk?tab=readme-ov-file) link repository on GitHub
- Hylé's [very simple introduction to zero-knowledge proofs](https://blog.hyle.eu/a-simple-introduction-to-zero-knowledge-proofs-zkp/)
- Lauri Peltonen's [blog series on ZK](https://medium.com/@laurippeltonen)
