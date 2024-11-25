---
title: Home
description: Hylé is the lean blockchain that makes building provable apps easy. This is your developer documentation.
---

# Welcome to the Hylé developer docs

**This developer portal and the project itself are still in early development. [Reach out to us on Telegram](https://t.me/hyle_org) if you need anything that isn't here.**

[Hylé](https://hyle.eu/)  is a lean blockchain that helps you build provable applications that are minimally, yet sufficiently, onchain.

- Hylé separates transaction sequencing from settlement, moving proof generation out of the latency-critical path. [Pipelined proving](https://blog.hyle.eu/an-introduction-to-delayed-proving/) solves ZK's current slowness problem and allows you to offload proof generation.
- Hylé has no on-chain execution or virtual machine, relying only on efficient native verification of zero-knowledge proofs.
- Hylé [verifies all zero-knowledge proofs natively](https://blog.hyle.eu/proof-verification-needs-to-change/): choose your proving scheme and your language.
- Hylé enables composability for provable applications, reaching abstraction levels comparable to shared execution. No more foreign field arithmetic or recursive proving; just batch your proofs as part of the same transaction and Hylé will match them.

![Diagram of the different steps coming before Hylé settlement. The diagram is in three parts. The first part, titled Application, includes the use cases (zkRollup, zkApp, zkCoprocessor, zkGaming, zkML, zkDID, and so on). Then it shows execution (via Kakarot, MidenVM, CairoVM, Polygon zkEVM) and data availability (Celestia, Avail, Ethereum). The second part of the diagram is the Prover, with the proof system (groth16, SP1, Cairo, Risc0, Gnark, Valida) and the proving service (Gevulot, client-side, Taralli, Succinct Labs). The third part is the Verifier, Hylé, which only stocks the name of the contract, the proof system and the state commitment.](./assets/img/main-diagram-large-detailed.png)

For more information, [check out our website](https://hyle.eu).

## Getting started

1. Check out how to [install the CLI](developers/using-the-cli/hyled-install-instructions.md)
1. Connect to [our public devnet](developers/using-the-cli/connect-to-devnet.md)
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