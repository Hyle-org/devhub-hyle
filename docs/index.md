---
description: Hylé is the new-generation Layer 1 network for the era of unchained applications. This is your developer documentation.
---

# Home

[Hylé](https://hyle.eu/) is the new-generation Layer 1 network for the era of unchained applications.

!!! note
    This developer portal and the project itself are still evolving. [Join us on Telegram](https://t.me/hyle_org) if you need assistance or wish to provide feedback. Issues and PRs on [this documentation's GitHub repository](https://github.com/Hyle-org/devhub-hyle) are also very welcome!

## Why choose Hylé

- Native zero-knowledge proof verification on our sovereign L1: we're fast and lean.
- No onchain execution or virtual machine needed: only efficient proof verification.
- Run complex logic off-chain and only submit proofs onchain for maximum scalability.
- Authenticate effortlessly with any identity provider.
- Interoperate with other smart contracts like it’s an API call.
- Pipelined proving: send provable blobs, don't worry about proving times.
- Unlock Web2 speed with a state-of-the-art consensus protocol for DA & settlement.
- Choose your proving scheme and your language: we verify all proofs.

## How Hylé works

Here’s what happens when you use Hylé’s next-generation base layer:

![Sequence diagram explaining the steps as listed below.](./assets/img/hyle-main-diagram.jpg)

1. **Sequencing**: Send a provable blob of information to Hylé: say what information you expect to prove later. We'll sequence the transaction immediately and give you time to prove it. [Read more about pipelined proving](https://blog.hyle.eu/an-introduction-to-delayed-proving/).
1. **Proof submission**: when the proofs for your transaction are ready, send them to Hylé.
1. **Verification**: Hylé validators receive the transaction. They verify the proofs natively, without the limitations of a bulky virtual machine.
1. **Consensus**: if the proofs are valid, Hylé settles your transaction's state onchain. You're good to go!

With this system, execution and storage happen **anywhere you like**. You only need a fast and trustworthy verifier: that’s Hylé.

## Links

- [Rust node](http://github.com/hyle-org/hyle)
- [Example contracts](http://github.com/hyle-org/examples)
- [Hyle.eu](https://hyle.eu)
- [Hylé blog](https://blog.hyle.eu)

Reach out to the team for more information:

| :fontawesome-brands-github: Github | :fontawesome-brands-twitter: Twitter | :fontawesome-solid-archway: Farcaster | :fontawesome-brands-linkedin: LinkedIn | :fontawesome-brands-youtube: Youtube |:fontawesome-brands-telegram: Telegram|
|-------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|
| [Hylé](https://github.com/Hyle-org) | [@hyle_org](https://x.com/hyle_org)  | [@hyle-org](https://warpcast.com/hyle-org) | [Hylé](https://www.linkedin.com/company/hyl-/) | [@Hylé](https://www.youtube.com/@Hyl%C3%A9-org) | [@hyle_org](https://t.me/hyle_org)|
