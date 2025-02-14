# Proving schemes

Proving schemes are the cryptographic protocols that make zero-knowledge proofs usable.

We support as many as we can, giving you the flexibility to choose the most suitable protocol for your specific use case.

## Supported proving schemes

As of December 2024, Hylé currently supports the following zero-knowledge proving schemes:

- [Noir](https://noir-lang.org/docs/)
- [Risc0](https://risc0.com/docs/)
- [SP1](https://docs.succinct.xyz/docs/introduction)

## Native verification

We verify these natively, without the need for a ZK proof.

- sha3_256
- BLST signatures

## Planned future support

We plan to support all major proving schemes eventually.

The next proving schemes we're aiming to support are:

- [Cairo](https://www.cairo-lang.org/docs/) via Stwo
- [Groth16](https://github.com/arkworks-rs/groth16)
