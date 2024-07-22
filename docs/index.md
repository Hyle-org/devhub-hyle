---
title: Home
description: Hylé is your minimal layer one, focused only on verifying zero-knowledge proofs. This is your developer documentation.
---

# Welcome to the Hylé developer docs

!!! note
    This developer portal and the project itself are still in early development. See below on how to reach out to us if you need anything that isn't here.

[Hylé](https://www.hyle.eu/) is your minimal layer one, focused only on verifying zero-knowledge proofs.

By sending a simple proof to be verified on Hylé, you can build a fully off-chain application powered by ZKPs that still has the security guarantees of the blockchain.

- Hylé only verifies zero-knowledge proofs: settlement is all you need.
- Hylé uses minimal storage: we only store the source of truth and our nodes are very light.
- Hylé is modular by design, for full flexibility.
- Hylé does not reinvent the wheel: we leverage existing tech stacks (Cairo, Risc0, SP1, etc.)

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

- [Main repository](http://github.com/hyle-org/hyle) (cosmos SDK app)
- [Hyle.eu](https://hyle.eu)
- [Hylé blog](https://blog.hyle.eu)

## Contact us

Feel free to reach out to the team for more information:  

- X [@hyle_org](http://twitter.com/hyle_org)
- Farcaster [@hyle-org](https://warpcast.com/hyle-org)
- Telegram [@hyle_org](https://t.me/hyle_org)
- Mail [contact@hyle.eu](mailto:contact@hyle.eu)