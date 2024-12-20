# Hylé vs. vintage blockchains

If you're used to traditional blockchains such as Ethereum or Solana, keep these Hylé characteristics in mind.

## No EVM or execution layer

Hylé does not include a Virtual Machine.

There is no dedicated execution engine or specific programming language (like Solidity) you should use.

Our approach is simple: onchain, we verify zero-knowledge proofs natively. Offchain, you do everything else, the way you prefer.

## No onchain state

The network maintains proofs of state transitions rather than the entire onchain state.

Transactions on Hylé verify and settle transitions without storing full intermediary states onchain.

This architecture reduces storage overhead and promotes scalability while maintaining trustlessness.

## Privacy is built-in

Unlike Ethereum, where privacy solutions must be implemented on top of the platform, Hylé integrates privacy features natively.

The proof is public, but your inputs don't need to be, as execution happens offchain.
