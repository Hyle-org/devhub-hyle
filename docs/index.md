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

![Diagram of the different steps coming before Hylé settlement. The diagram is in three parts. The first part, titled Application, includes the use cases (zkRollup, zkApp, zkCoprocessor, zkGaming, zkML, zkDID, and so on). Then it shows execution (via Kakarot, MidenVM, CairoVM, Polygon zkEVM) and data availability (Celestia, Avail, Ethereum). The second part of the diagram is the Prover, with the proof system (groth16, SP1, Cairo, Risc0, Gnark, Valida) and the proving service (Gevulot, client-side, Taralli, Succinct Labs). The third part is the Verifier, Hylé, which only stocks the name of the contract, the proof system and the state commitment.](./assets/img/main-diagram-large-detailed.png)

## Getting started

1. [Run your own devnet](run-devnet.md) or [Connect to the public devnet](connect-to-devnet.md)
1. Learn how to [create your first smart contract](developers/using-the-cli/your-first-smart-contract.md)

## Our use cases

- [Vibe Check](https://blog.hyle.eu/introducing-vibe-check/), our zkML & WebAuthn-powered demo
- [Hylé for provable apps](use-cases/for-zk-apps.md) (read: [what is a provable app?](https://blog.hyle.eu/what-is-a-provable-app/))
- [Hylé for identity providers & wallets](https://blog.hyle.eu/smart-wallets-must-be-provable/)
- [Hylé for a provable play-by-email game engine](https://github.com/MatteoMer/provable-email-game-engine)
- ...

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