# Identity management

Identity [in traditional blockchains](./hyle-vs-vintage-blockchains.md) is often tied to a single wallet address, which limits flexibility and privacy.

Hylé introduces a **proof-based identity model**. Instead of relying on fixed addresses or centralized registries, your application can use cryptographic proofs of identity.

This approach allows users to authenticate with any identity source: meet users where they are and don't worry about onboarding and clunky wallets!

## Choosing an identity source

On Hylé, any smart contract can be used as a proof of identity. This flexibility enables you to register your preferred identity source as a smart contract for account authentication.

Here are some important aspects of identity contracts:

- Identity contracts define how proofs of identity are verified and validated.
- Applications decide which identities to accept. A contract can enforce specific identity types (e.g., Google accounts only) or support multiple sources simultaneously.
- Identity providers must provide a verifiable signature to be secure.
- A transaction can seamlessly send Hylé tokens between any identity types, such as from a Metamask wallet to an email and password-based account: using proofs as identities on Hylé means there is perfect interoperability.
- There are no Hylé-specific wallets. Users authenticate using any proof supported by their application.

If you don't want to create a custom identity source for early development, Hylé provides [a native `hydentity` contract](https://github.com/Hyle-org/hyle/tree/main/crates/contracts/hydentity). This contract is not secure and should not be used in production.

## How Hylé processes identity proofs

As explained in [our transactions concept page](./transaction.md), a `BlobTransaction` on Hylé can include multiple blobs. One of these blobs must be an identity claim.

- Each blob transaction requires a single identity.
- All provable blobs in a transaction must share the same identity.
- Identity proofs must include a nonce to prevent replay attacks.
- The proof verification process ensures the identity was correctly provided.

## Custom identity contracts

Applications on Hylé can implement custom identity verification rules through smart contracts. A typical identity contract includes two core functions, as shown in [our identity quickstart](../quickstart/custom-identity-contract.md):

- **Register**: Users submit an initial proof of identity.
- **Verify**: The contract validates the proof against predefined rules.

Applications can use this structure or define their own identity workflows as needed.
