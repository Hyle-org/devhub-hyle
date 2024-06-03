---
title: Hylé overview
---

# About Hylé

[Hylé](https://www.hyle.eu/) is your minimal layer one, focused only on verifying zero-knowledge proofs.

By sending a simple proof to be verified on Hylé, you can build a fully off-chain application powered by ZKPs that still has the security guarantees of the blockchain.

![diagram of a zero knowledge proof, hyle does settlement and consensus but not execution and storage](https://assets-global.website-files.com/6602f1114b957961e0b12dc7/660c9ce163593772242cf9a0_diagram_zero-knowledge-proofs.svg)

## Why Hylé?

- Leverage the power of zero-knowledge proofs for maximum trustlessness and privacy
- Run complex logic in your smart contracts thanks to off-chain execution
- Lower your storage costs with efficient and trustless storage proofs
- Enjoy better readability with our native on-chain Name System
- Freely create transactions composing private and public inputs

You can **execute your smart contracts off-chain** anywhere you like, on a rollup, on-premise or even client-side.

You can **store your data** securely in your backend, IPFS, Arweave or any other long-term solution: Hylé provides the verifiable source of truth for your end user.

You can choose your proving scheme, your language, your prover, and still get instant finality and enhanced security.

## How does it work?

![Diagram of the different steps coming before Hylé settlement. The diagram is in three parts. The first part, titled Application, includes the use cases (zkRollup, zkApp, zkCoprocessor, zkGaming, zkML, zkDID, and so on). Then it shows execution (via Kakarot, MidenVM, CairoVM, Polygon zkEVM) and data availability (Celestia, Avail, Ethereum). The second part of the diagram is the Prover, with the proof system (groth16, SP1, Cairo, Risc0, Gnark, Valida) and the proving service (Gevulot, client-side, Taralli, Succinct Labs). The third part is the Verifier, Hylé, which only stocks the name of the contract, the proof system and the state commitment.](../assets/img/main-diagram-large-detailed.svg)

Using Hylé’s sovereign verification-focused Layer 1, here’s what happens:

1. No need for a **verifier contract**: just call the native function.
1. **Proof generation**: This doesn’t change. Off-chain, the prover generates a zero-knowledge proof of a specific computation.
1. **Proof submission**: the prover sends the proof and the results of the computation to Hylé’s Layer 1 as part of a transaction.
1. **Verification**: Hylé validators receive the transaction. They use the native verification programs to check the validity of the proof as fast as possible, without being limited by the bulky virtual machine.
1. **Consensus and block inclusion**: if the proof is valid, the block producer puts the results of the computation on the Hylé blockchain.

And that’s it.

With this system, execution and storage happen anywhere you like, without cost barriers. You only need a fast and trustworthy verifier: that’s Hylé.

For more information, [check out our website](https://hyle.eu).