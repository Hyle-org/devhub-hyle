---
title: Understanding zero-knowledge proofs
---

Here are some resources on zero-knowledge proofs and how to generate them.

## When to use zero-knowledge proofs

There are three moments when ZK is the right tool for you:

- **Computing power imbalance** (which includes improved **scalability**): I run resource-heavy computation anywhere and verify the result.
- **Adversarial environment**: I can verify a result without knowing trade secrets that attained this result.
- **Anonymity**: I share only the information I want to share.

## How to use zero-knowledge proofs

There are [many ZK languages](https://github.com/microbecode/zk-languages). Hylé aims to verify [as many as possible](../concepts/supported-proving-schemes.md).

DSLs, like Circom, are specific languages that usually compile down to a specific circuit. They're good, but they're complex and may have a high learning curve.

zkVMs prove the correct execution of arbitrary code. They allow you to build ZK applications in a certain language without having to build a circuit around it. There are two main types of zkVMs: Cairo and RISC-V. You can benchmark your Rust code and find the best zkVM for your needs with [the any-zkvm template](https://github.com/MatteoMer/any-zkvm).

We currently support RISC–V-based zkVMs [Risc0](https://risc0.com/docs/) and [SP1](https://docs.succinct.xyz/) and will support more types, including Cairo-based zkVMs and DSLs, in the future.

## Read more

- [Zero-knowledge proofs explained at 5 levels of difficulty](https://www.youtube.com/watch?v=fOGdb1CTu5c) (22')
- [awesome-zk](https://github.com/ventali/awesome-zk?tab=readme-ov-file) link repository on GitHub
- Hylé's [very simple introduction to zero-knowledge proofs](https://blog.hyle.eu/a-simple-introduction-to-zero-knowledge-proofs-zkp/)
- Lauri Peltonen's [blog series on ZK](https://medium.com/@laurippeltonen)
