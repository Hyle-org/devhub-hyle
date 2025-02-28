# Proof generation and submission

Hylé allows you to build unchained applications by leveraging zero-knowledge proofs. They allow you to avoid onchain execution, guarantee privacy, and customize your application while maintaining composability with other smart contracts.

With Hylé, generate your proof wherever you prefer, then send it for native onchain verification and settlement. This process enables scalable, modular applications with customizable proving schemes.

If you're a complete beginner with zero-knowledge proofs, [our no-code introduction](https://blog.hyle.eu/a-simple-introduction-to-zero-knowledge-proofs-zkp/) might help.

## Generating zero-knowledge proofs for Hylé

### Choose what you prove

Each application defines its proof logic. This means that each application developer can decide **what information** gets proven: for Hylé, proof settlement is a Success or a Failure. You define what that means for your app.

Each app developer also defines what the **public and private inputs** of their app will be: what information should remain private and what should go onchain?

### How to generate a zero-knowledge proof

There are [many ZK languages](https://github.com/microbecode/zk-languages). Hylé aims to verify as many as possible.

DSLs, like Circom, are specific languages that usually compile down to a specific circuit. They're good, but they're complex and may have a high learning curve.

zkVMs prove the correct execution of arbitrary code. They allow you to build ZK applications in a certain language without having to build a circuit around it. There are two main types of zkVMs: Cairo and RISC-V. You can benchmark your Rust code and find the best zkVM for your needs with [the any-zkvm template](https://github.com/MatteoMer/any-zkvm).

Each application can generate its proof in whichever place fits best.

|                                   | Pros                                                                           | Cons                                                    | When to use                                         |
|-----------------------------------|--------------------------------------------------------------------------------|---------------------------------------------------------|-----------------------------------------------------|
| Client-side (browser, mobile app) | Maximum privacy<br>Data ownership                                              | Requires robust client-side hardware                    | Personal data that should remain private            |
| External prover or proving market | No client-side costs or constraints<br>Offload proof generation to the experts | Requires trusting the external prover with your inputs  | Resource-intensive and not privacy-sensitive proofs |
| By the application itself         | Simple UX<br>No dependencies<br>Code can be private                            | Higher infrastructure needs<br>Potential liveness issue | Confidential or centralized applications            |

### Our supported proving schemes

Proving schemes are the cryptographic protocols that make zero-knowledge proofs usable. We support as many as we can, giving you the flexibility to choose the most suitable protocol for your specific use case.

We've written templates for some of our supported programs. Clone them to [get started](../quickstart/your-first-smart-contract.md) with smart contract writing.

| Proving scheme | Verifier | Program ID | Template                                       |
|----------------|----------|---------------------------------------------------|---|
| [Noir](https://noir-lang.org/docs/)           | noir     | Verification key.                                 |   - |
| [Risc0](https://risc0.com/docs/)      | risc0    | Image ID without a prefix. ex. 0x123 becomes 123. | [Template](https://github.com/Hyle-org/risc0-template)  |
| [SP1](https://docs.succinct.xyz/sp1/introduction)            | sp1      | Verification key.                                 |   - |

We also verify these natively, without the need for a ZK proof.

- sha3_256
- BLST signatures

We will support more types, including Cairo-based zkVMs and DSLs, in the future, and plan to support all major proving schemes eventually. The next proving schemes we're aiming to support are [Cairo](https://www.cairo-lang.org/docs/) via Stwo and [Groth16](https://github.com/arkworks-rs/groth16).

### Our proof generation partners

If you choose to work with an external prover or proving market, you can choose from one of our partners in that area and benefit from a better Hylé integration.

We recommend checking out [Electron](https://electron.dev/), [Fermah](https://www.fermah.xyz/), [Kakarot](https://www.kakarot.org/), [Marlin](https://www.marlin.org/), [Nexus](https://nexus.xyz/), [Nodekit](https://www.nodekit.xyz/), [ZEROBASE](http://zerobase.pro/), or [zkCloud](https://zkcloud.com/).

## Submitting a proof to Hylé

Read more about the transaction lifecycle on our [transactions overview](./transaction.md).

First, your application sends a blob transaction to Hylé.

Thanks to [pipelined proving](./pipelined-proving.md), once a transaction is submitted, it is sequenced.

You can then start generating your proof using the sequenced virtual base state as the base state for your operation. [Read our quickstart](../quickstart/example/your-first-smart-contract.md#prove-the-transaction) for a concrete example of how to prove a transaction.

Once sent, the proof goes through Hylé’s native verification, removing the need for verifier contracts.

Once verified, the proof is settled onchain. Use this settled state to update your app accordingly outside of Hylé.

## External resources

- [Zero-knowledge proofs explained at 5 levels of difficulty](https://www.youtube.com/watch?v=fOGdb1CTu5c) (22')
- [awesome-zk](https://github.com/ventali/awesome-zk?tab=readme-ov-file) link repository on GitHub
- Hylé's [very simple introduction to zero-knowledge proofs](https://blog.hyle.eu/a-simple-introduction-to-zero-knowledge-proofs-zkp/)
- Lauri Peltonen's [blog series on ZK](https://medium.com/@laurippeltonen)
