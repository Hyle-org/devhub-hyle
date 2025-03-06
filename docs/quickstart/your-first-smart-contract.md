# Your first smart contract

!!! tip
    Check our [example walkthrough](./example/index.md) for more!

## Step 1: Clone a template

We support [several proving schemes](../concepts/proof-generation.md#our-supported-proving-schemes):

- [risc0](https://github.com/Hyle-org/template-risc0)
- [SP1](https://github.com/Hyle-org/template-sp1)
- Noir (no template available)

Clone the template or, for proving schemes without templates, use the templates as inspiration for writing your contract. You can also check our [smart contract concept page](../concepts/smart-contracts.md) for more information!

## Step 2: Edit your contract

Navigate to the `contract/` folder and edit your contract as necessary.

## Step 3: Register your contract

On [the devnet](./devnet.md), register your contract by running:

```sh
cargo run -- register-contract
```
