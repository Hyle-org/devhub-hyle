# Release notes

Read our [full changelogs on GitHub](https://github.com/Hyle-org/hyle/releases/) or the short versions [in our Telegram group](https://t.me/hyle_org).

## 2025-01-27 − v0.8.0

💥 Breaking changes:

- Hyle-contracts: Merged the contracts ‘metadata’ feature into ‘client’
- There are no more `RegisterContract` transactions: contracts are now registered with `BlobTransactions`, like everything else.
- Contract registration has been reworked using proof outputs; we introduced UUID contract names ([see uuid-tld](https://github.com/Hyle-org/hyle/tree/88ba05b5da901e13ff2fb3620c23a64f8cc44093/crates/contracts/uuid-tld) for an example).
- Removed `hyled` and `hyrun`. If you were using them, check out our SDK instead.

✨New features:

- You can now settle transactions that have a proof of failure before they timeout
- Made progress on the implementation of our consensus

🚅 Improvements:

- We now enforce a recent Rust version to avoid errors.

🛠️ No longer broken:

- Bug fixes include Dockerfile, environment variables, and identities.

📚 Documentation:

- Our [SDK has a README](https://github.com/Hyle-org/hyle/tree/main/crates/contract-sdk) now!

Read the [full changelog on GitHub](https://github.com/Hyle-org/hyle/releases/tag/v0.8.0).

## 2025-01-21 − v0.7.1 & v0.7.2

Small patches for our SDK.

Read release notes [for v0.7.1](https://github.com/Hyle-org/hyle/releases/tag/v0.7.1) and [v0.7.2](https://github.com/Hyle-org/hyle/releases/tag/v0.7.2); see new [SDK readme](https://github.com/Hyle-org/hyle/tree/main/crates/contract-sdk) for more info.

## 2025-01-20 − v0.7.0

💥 Breaking changes:

- We completely rewrote the dependencies for the SDK.

✨ New features;

- Adding support of native verifiers. Verify hash signatures, TEE executions without needing a ZK proof! Currently supported: sha3_256 & BLST signatures.
- You can now use `tx hash` inside contracts

🚅 Improvements:

- Several performance improvements following our latest loadtest
- Reduce log verbosity and frequency
- Dependencies: updated risc0-zkvm to 1.2.1, sp1-sdk to 4.0.0

🛠️ No longer broken:

- Loads of bug fixes − check the full release to know more.

📚 Documentation:

- [Transactions on Hylé](https://docs.hyle.eu/developers/general-doc/transaction/)
- [Identity management](https://docs.hyle.eu/developers/general-doc/identity/)

Read the [full changelog on GitHub](https://github.com/Hyle-org/hyle/releases/tag/v0.7.0) and receive future release notes [in our Telegram group](https://t.me/hyle_org).

## 2025-01-13 − v0.6.0

✨ New features:

- Added [the SP1 prover](https://docs.succinct.xyz/docs/introduction) to the client SDK.

🚅 Improvements:

- Upgraded to SP1 4.0.0-rc8.

🛠️ No longer broken:

- Fixed the default configurations.
- Fixed loading state when restarting a node.

📚 Documentation:

- Rewrote [our Quickstart guide](https://docs.hyle.eu/developers/quickstart/).

Read the [full changelog on GitHub](https://github.com/Hyle-org/hyle/releases/tag/v0.6.0) and receive future release notes [in our Telegram group](https://t.me/hyle_org).
