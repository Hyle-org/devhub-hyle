---
title: Supported proving schemes
description: The list of zero-knowledge proving schemes currently supported by Hylé.
---

# Supported Proving Schemes

Hylé currently supports the following zero-knowledge proving schemes:

- [Risc0](https://risc0.com/docs/)
- [Groth16](https://github.com/arkworks-rs/groth16) (over BN254; others can be implemented manually)
- [Cairo](https://www.cairo-lang.org/docs/) via Stark Platinum (partial support)
- [Noir](https://noir-lang.org/docs/) via Barretenberg

## Planned Future Support

We plan to eventually support all major proving schemes.

The next proving schemes we're aiming to support are:

- Full support of [Cairo](https://www.cairo-lang.org/docs/) including via Stwo
- [SP1](https://docs.succinct.xyz/docs/introduction) 
- PlonK