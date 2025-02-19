# Hylé vs. vintage blockchains

If you're used to traditional blockchains such as Ethereum or Solana, keep these Hylé characteristics in mind.

## No EVM or execution layer

Hylé does not include a Virtual Machine.

There is no dedicated execution engine or specific programming language (like Solidity) you should use.

Our approach is simple: onchain, we verify zero-knowledge proofs natively. Offchain, you do everything else the way you prefer. This gives you higher throughput, faster finality, and lower gas fees.

## Minimal onchain state

The network maintains proofs of state transitions rather than the entire onchain state.

Transactions on Hylé verify and settle transitions without storing full intermediary states onchain.

This architecture reduces storage overhead and promotes scalability while maintaining trustlessness.

## No wallets

Stop asking yourself, «Which wallet do I use? How do I bridge? ». With Hylé, there are no wallets and no bridges − any identity source that can be attested with a zero-knowledge proof is a valid identity.

## Every app is a rollup

On Hylé, there is one general-purpose blockchain, and every app is its own based ZK-rollup, removing the problems associated with fragmentation.

An app’s transactions are sequenced directly on the Hylé base layer. They are split into a blob transaction, which allows for [pipelined proving](https://docs.hyle.eu/developers/general-doc/pipelined-proving/), and a proof transaction to store the state commitment onchain.

## Privacy is built-in

Unlike Ethereum, where privacy solutions must be implemented on top of the platform, Hylé integrates privacy features natively.

The proof is public, but your inputs don't need to be, as execution happens offchain.
