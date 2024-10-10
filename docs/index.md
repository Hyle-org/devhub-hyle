---
title: Home
description: Hylé is the lean blockchain that makes building provable apps easy. This is your developer documentation.
---

# Welcome to the Hylé developer docs

!!! note
This developer portal and the project itself are still in early development. See below on how to reach out to us if you need anything that isn't here.

[Hylé](https://hyle.eu/)  is a lean blockchain that helps you build provable applications that are minimally, yet sufficiently, onchain.

- Hylé only verifies zero-knowledge proofs: sequencing settlement is all you need.
- Hylé uses minimal storage: we only store the source of truth and our nodes are very light.
- Hylé is modular by design, for full flexibility.
- Hylé does not reinvent the wheel: we leverage existing tech stacks (Cairo, Risc0, SP1, etc.)
- Hylé uses delayed proving: we remove the proof from your app's critical path and let you build without constraints.

![Diagram of the different steps coming before Hylé settlement. The diagram is in three parts. The first part, titled Application, includes the use cases (zkRollup, zkApp, zkCoprocessor, zkGaming, zkML, zkDID, and so on). Then it shows execution (via Kakarot, MidenVM, CairoVM, Polygon zkEVM) and data availability (Celestia, Avail, Ethereum). The second part of the diagram is the Prover, with the proof system (groth16, SP1, Cairo, Risc0, Gnark, Valida) and the proving service (Gevulot, client-side, Taralli, Succinct Labs). The third part is the Verifier, Hylé, which only stocks the name of the contract, the proof system and the state commitment.](./assets/img/main-diagram-large-detailed.png)

For more information, [check out our website](https://hyle.eu).

## Getting started

1. Check out how to [install the CLI](developers/using-the-cli/hyled-install-instructions.md)
1. Connect to [our public devnet](developers/using-the-cli/connect-to-devnet.md)
1. Learn how to [create your first smart contract](developers/using-the-cli/your-first-smart-contract.md)

## Our use cases

- [Hylé for ZKApps](use-cases/for-zk-apps.md)
- [Hylé for identity providers & wallets](use-cases/for-identity-providers.md)
- Hylé for RAAS & ZK Coprocessors (coming soon)
- ...

## Useful links

- [Rust WIP node](http://github.com/hyle-org/hyle)
- [Hyle.eu](https://hyle.eu)
- [Hylé blog](https://blog.hyle.eu)

## Contact us

Feel free to reach out to the team for more information:

- :fontawesome-brands-github: Github: [@hyle_org](http://twitter.com/hyle_org)
- :fontawesome-brands-twitter: Twitter: [@hyle_org](https://x.com/hyle_org)
- :fontawesome-solid-archway: Farcaster: [@hyle-org](https://warpcast.com/hyle-org)
- :fontawesome-brands-linkedin: LinkedIn: [Hylé](https://www.linkedin.com/company/hyl-/)
- :fontawesome-brands-youtube: Youtube: [@Hylé](https://www.youtube.com/@Hyl%C3%A9-org)
- :fontawesome-brands-telegram: Telegram: [@hyle_org](https://t.me/hyle_org)
