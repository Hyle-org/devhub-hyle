# Your first smart contract

!!! tip
    Check our [example walkthrough](./example/your-first-smart-contract.md) for more!

## Step 1: Clone a template

We support [several proving schemes](../concepts/proof-generation.md#our-supported-proving-schemes) and provide templates for the following:

- [risc0](https://github.com/Hyle-org/risc0-template)
<!--- [SP1](https://github.com/Hyle-org/sp1-template)-->

## Step 2: Edit your contract

Navigate to the `contract/` folder and edit your contract as necessary.

## Step 3: Register your contract

On [the devnet](./devnet.md), register your contract by running:

```sh
cargo run -- register-contract
```
