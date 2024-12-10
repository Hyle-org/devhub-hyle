---
title: Understanding zero-knowledge proofs
---

Here are some resources on zero-knowledge proofs and how to generate them.

## When to use zero-knowledge proofs

There are three moments when ZK is the right tool for you:

- **Computing power imbalance** (which includes improved **scalability**)
- **Adversarial environment**
- **Anonymity**

## How to use zero-knowledge proofs

There are [many ZK languages](https://github.com/microbecode/zk-languages). Hylé aims to verify [as many as possible](../developers/general-doc/supported-proving-schemes.md).

With a zkVM, you can prove the correct execution of arbitrary code. This allows you to build ZK applications in languages you already know like Rust and C++, without having to build a circuit.

Find the documentation for the proof systems we currently support:

- [Risc0](https://risc0.com/docs/)
- [SP1](https://docs.succinct.xyz/)

## Read more

- [awesome-zk](https://github.com/ventali/awesome-zk?tab=readme-ov-file) link repository on GitHub
- Hylé's [very simple introduction to zero-knowledge proofs](https://blog.hyle.eu/a-simple-introduction-to-zero-knowledge-proofs-zkp/)
- Lauri Peltonen's [blog series on ZK](https://medium.com/@laurippeltonen)