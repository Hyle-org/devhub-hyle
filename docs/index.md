---
title: Home
description: Hylé is the lean blockchain that makes building provable apps easy. This is your developer documentation.
---

# Welcome to the Hylé developer docs

**This developer portal and the project itself are still in early development. [Reach out to us on Telegram](https://t.me/hyle_org) if you need anything that isn't here or find outdated information.**

[Hylé](https://hyle.eu/)  is a lean blockchain that helps you build provable applications that are minimally, yet sufficiently, onchain.

We focus on native verification of zero-knowledge proofs.

- Native zero-knowledge proof verification on our sovereign L1.
- No onchain execution or virtual machine: only efficient proof verification.
- Run complex logic in your smart contracts thanks to off-chain execution.
- Leverage pipelined proving and bring proof generation outside of your app's critical path.
- Choose your proving scheme and your language: we verify all proofs.
- Composable cross-contract calls, reaching abstraction levels comparable to shared execution. You'll never need to recursively verify a proof again!

## How does Hylé work?

Here’s what happens when you use Hylé’s sovereign verification-focused Layer 1:

1. No need for a **verifier contract**: just call the native function.
1. **Proof generation**: off-chain, the prover generates a zero-knowledge proof of a specific computation.
1. **Proof submission**: the prover sends the proof(s) and the results of the computation to Hylé's Layer 1 as part of a transaction. If there are several proofs, that's not a problem: we offer proof composability.
1. **Pipelined proving**: the state is updated temporarily to remove proving time from your app's critical path. [Read more on our blog](https://blog.hyle.eu/an-introduction-to-delayed-proving/).
1. **Verification**: Hylé validators receive the transaction. They use the native verification programs to check the validity of the proof as fast as possible, without being limited by the bulky virtual machine.
1. **Consensus and block inclusion**: if the proof is valid, the block producer puts the results of the computation on the Hylé blockchain and the state is updated onchain.

And that’s it.

![Diagram of the different steps coming before Hylé settlement. The diagram is in three parts. The first part, titled Application, includes the use cases (zkRollup, zkApp, zkCoprocessor, zkGaming, zkML, zkDID, and so on). Then it shows execution (via Kakarot, MidenVM, CairoVM, Polygon zkEVM) and data availability (Celestia, Avail, Ethereum). The second part of the diagram is the Prover, with the proof system (groth16, SP1, Cairo, Risc0, Gnark, Valida) and the proving service (Gevulot, client-side, Taralli, Succinct Labs). The third part is the Verifier, Hylé, which only stocks the name of the contract, the proof system and the state commitment.](../assets/img/main-diagram-large-detailed.png)

With this system, execution and storage happen anywhere you like, without cost barriers. You only need a fast and trustworthy verifier: that’s Hylé.

## Getting started

1. [Run your own devnet](./developers/getting-started/run-devnet.md) or [Connect to the public devnet](./developers/getting-started/connect-to-devnet.md)
1. Learn how to [create your first smart contract](developers/getting-started/your-first-smart-contract.md)

## Useful links

- [Rust WIP node](http://github.com/hyle-org/hyle)
- [Hyle.eu](https://hyle.eu)
- [Hylé blog](https://blog.hyle.eu)

## Contact us

Feel free to reach out to the team for more information:

- :fontawesome-brands-github: Github: [Hylé](https://github.com/Hyle-org)
- :fontawesome-brands-twitter: Twitter: [@hyle_org](https://x.com/hyle_org)
- :fontawesome-solid-archway: Farcaster: [@hyle-org](https://warpcast.com/hyle-org)
- :fontawesome-brands-linkedin: LinkedIn: [Hylé](https://www.linkedin.com/company/hyl-/)
- :fontawesome-brands-youtube: Youtube: [@Hylé](https://www.youtube.com/@Hyl%C3%A9-org)
- :fontawesome-brands-telegram: Telegram: [@hyle_org](https://t.me/hyle_org)