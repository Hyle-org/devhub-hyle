---
title: Understanding zero-knowledge proofs
---

Here are some resources on zero-knowledge proofs and how to generate them.

## When to use zero-knowledge proofs

There are three moments when ZK is the right tool for you:

- **Computing power imbalance** (which includes improved **scalability**): I can verify a result without running the resource-heavy computation.
- **Adversarial environment**: I can verify a result without knowing trade secrets that attained this result.
- **Anonymity**: I share only the information I want to share.

## How to use zero-knowledge proofs

There are [many ZK languages](https://github.com/microbecode/zk-languages). Hylé aims to verify [as many as possible](../developers/general-doc/supported-proving-schemes.md).

With a zkVM, you can prove the correct execution of arbitrary code. This allows you to build ZK applications in a certain language without having to build a circuit around it.

Find the documentation for the proof systems we currently support:

- [Risc0](https://risc0.com/docs/)
- [SP1](https://docs.succinct.xyz/)

You can benchmark your Rust code with [the any-zkvm template](https://github.com/MatteoMer/any-zkvm).

## Read more

- [awesome-zk](https://github.com/ventali/awesome-zk?tab=readme-ov-file) link repository on GitHub
- Hylé's [very simple introduction to zero-knowledge proofs](https://blog.hyle.eu/a-simple-introduction-to-zero-knowledge-proofs-zkp/)
- Lauri Peltonen's [blog series on ZK](https://medium.com/@laurippeltonen)
