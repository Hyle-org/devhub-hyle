---
description: Hylé is the lean blockchain that makes building provable apps easy. This is your developer documentation.
---

# Home

[Hylé](https://hyle.eu/) is a lean blockchain that lets you easily take your provable application onchain.

!!! note
    This developer portal and the project itself are still evolving. [Join us on Telegram](https://t.me/hyle_org) if you need assistance or wish to provide feedback. Issues and PRs on [this documentation's GitHub repository](https://github.com/Hyle-org/devhub-hyle) are also very welcome!

## Why choose Hylé

- Native zero-knowledge proof verification on our sovereign L1: we're fast and lean.
- No onchain execution or virtual machine needed: only efficient proof verification.
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

With this system, execution and storage happen **anywhere you like**. You only need a fast and trustworthy verifier: that’s Hylé.

## Documentation

- [Get started now](developers/getting-started/index.md)
- [Learn more about Hylé](developers/general-doc/index.md)
- [Check out examples](developers/examples/index.md)

## Links

- [Rust node](http://github.com/hyle-org/hyle)
- [Hyle.eu](https://hyle.eu)
- [Hylé blog](https://blog.hyle.eu)

Reach out to the team for more information:

| :fontawesome-brands-github: Github | :fontawesome-brands-twitter: Twitter | :fontawesome-solid-archway: Farcaster | :fontawesome-brands-linkedin: LinkedIn | :fontawesome-brands-youtube: Youtube |:fontawesome-brands-telegram: Telegram|
|-------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|
| [Hylé](https://github.com/Hyle-org) | [@hyle_org](https://x.com/hyle_org)  | [@hyle-org](https://warpcast.com/hyle-org) | [Hylé](https://www.linkedin.com/company/hyl-/) | [@Hylé](https://www.youtube.com/@Hyl%C3%A9-org) | [@hyle_org](https://t.me/hyle_org)|
