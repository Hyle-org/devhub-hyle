# Release notes

Read our [full changelogs on GitHub](https://github.com/Hyle-org/hyle/releases/) or the short versions [in our Telegram group](https://t.me/hyle_org).

## 2025-01-21 − v0.7.1 & v0.7.2

Small patches for our SDK.

Read release notes [for v0.7.1](https://github.com/Hyle-org/hyle/releases/tag/v0.7.1) and [v0.7.2](https://github.com/Hyle-org/hyle/releases/tag/v0.7.2); see new [SDK readme](https://github.com/Hyle-org/hyle/tree/main/crates/contract-sdk) for more info.

## 2025-01-20 − v0.7.0

### 💥 Breaking changes

- We completely rewrote the dependencies for the SDK.

### ✨New features

- Adding support of native verifiers. Verify hash signatures, TEE executions without needing a ZK proof! Currently supported: sha3_256 & BLST signatures.
- You can now use `tx hash` inside contracts

### 🚅 Improvements

- Several performance improvements following our latest loadtest
- Reduce log verbosity and frequency
- Dependencies: updated risc0-zkvm to 1.2.1, sp1-sdk to 4.0.0

### 🛠️ No longer broken

- Loads of bug fixes − check the full release to know more.

### 📚 Documentation

- [Transactions on Hylé](https://docs.hyle.eu/developers/general-doc/transaction/)
- [Identity management](https://docs.hyle.eu/developers/general-doc/identity/)

Read the [full changelog on GitHub](https://github.com/Hyle-org/hyle/releases/tag/v0.7.0) and receive future release notes [in our Telegram group](https://t.me/hyle_org).

## 2025-01-13 − v0.6.0

### ✨ New features

- Added [the SP1 prover](https://docs.succinct.xyz/docs/introduction) to the client SDK.

### 🚅 Improvements

- Upgraded to SP1 4.0.0-rc8.

### 🛠️ No longer broken

- Fixed the default configurations.
- Fixed loading state when restarting a node.

### 📚 Documentation

- Rewrote [our Quickstart guide](https://docs.hyle.eu/developers/quickstart/).

Read the [full changelog on GitHub](https://github.com/Hyle-org/hyle/releases/tag/v0.6.0) and receive future release notes [in our Telegram group](https://t.me/hyle_org).
