---
title: Home
description: Hylé is the lean blockchain that makes building provable apps easy. This is your developer documentation.
---

# Welcome to the Hylé developer docs

[Hylé](https://hyle.eu/) is a lean blockchain that helps you build provable applications that are minimally, yet sufficiently, onchain.

**Note:** This developer portal and the project itself are still evolving. [Join us on Telegram](https://t.me/hyle_org) if you need assistance or wish to provide feedback. Issues and PRs on [this documentation's GitHub repository](https://github.com/Hyle-org/devhub-hyle) are also very welcome!

## Why Hylé?

- Native zero-knowledge proof verification on our sovereign L1: we're fast and lean.
- No onchain execution or virtual machine: only efficient proof verification.
- Run complex logic offchain and only submit proofs onchain for maximum scalability.
- Proof composability: seamlessly combine multiple proofs into single, verifiable transactions.
- Pipelined proving: send provable blobs, don't worry about proving times.
- Choose your proving scheme and your language: we verify all proofs.

## How Hylé works

Here’s what happens when you use Hylé’s sovereign verification-focused Layer 1:

1. **Sequencing**: Send a provable blob to Hylé: say what information you expect to prove later. We'll sequence the transaction immediately. [Read more about pipelined proving](https://blog.hyle.eu/an-introduction-to-delayed-proving/).
1. **Proof generation**: generate a zero-knowledge proof of a specific computation, or several if they depend on each other. [Read more about proof composability](https://blog.hyle.eu/proof-composability-on-hyle/).
1. **Proof submission**: when the proofs for your transaction are ready, send them to Hylé.
1. **Verification**: Hylé validators receive the transaction. They verify the proofs natively, without the limitations of a bulky virtual machine.
1. **Consensus**: if the proofs are valid, Hylé settles your transaction's state onchain. You're good to go!

![Diagram of the different steps coming before Hylé settlement. The diagram is in three parts. The first part, titled Application, includes the use cases (zkRollup, zkApp, zkCoprocessor, zkGaming, zkML, zkDID, and so on). Then it shows execution (via Kakarot, MidenVM, CairoVM, Polygon zkEVM) and data availability (Celestia, Avail, Ethereum). The second part of the diagram is the Prover, with the proof system (groth16, SP1, Cairo, Risc0, Gnark, Valida) and the proving service (Gevulot, client-side, Taralli, Succinct Labs). The third part is the Verifier, Hylé, which only stocks the name of the contract, the proof system and the state commitment.](../assets/img/main-diagram-large-detailed.png)

With this system, execution and storage happen anywhere you like, without cost barriers. You only need a fast and trustworthy verifier: that’s Hylé.

## Documentation

- [Get started now](developers/getting-started/index.md)
- [Learn more about Hylé](developers/general-doc/index.md)
- [Check out examples](developers/examples/index.md)

## Links

- [Rust WIP node](http://github.com/hyle-org/hyle)
- [Hyle.eu](https://hyle.eu)
- [Hylé blog](https://blog.hyle.eu)

Feel free to reach out to the team for more information:

## Stay Connected 🤝

Have questions, feedback, or just want to say hi? Reach out to us through your favorite platform—we’d love to hear from you!

- :fontawesome-brands-github: [GitHub](https://github.com/Hyle-org)
- :fontawesome-brands-twitter: [Twitter](https://x.com/hyle_org)
- :fontawesome-solid-archway: [Farcaster](https://warpcast.com/hyle-org)
- :fontawesome-brands-linkedin: [LinkedIn](https://www.linkedin.com/company/hyl-/)
- :fontawesome-brands-youtube: [Youtube](https://www.youtube.com/@Hyl%C3%A9-org)
- :fontawesome-brands-telegram: [Telegram](https://t.me/hyle_org)