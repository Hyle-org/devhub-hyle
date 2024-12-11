# Collatz example

Hylé smart contracts can be written in any language that targets one of our [supported proving schemes](../general-doc/supported-proving-schemes.md).

On this page, we'll use the RISC Zero Collatz Conjecture program, which can be found [in our examples repository](https://github.com/Hyle-org/examples/tree/main).

## What is the Collatz conjecture?

The Collatz conjecture is a simple mathematical problem that can be expressed as a program.  

The conjecture states that, for any positive integer `n`:

- if `n` is even, divide it by 2
- if `n` is odd, multiply it by 3 and add 1
- repeat this process, and you will eventually reach 1.

The program is implemented in Rust, and compiles to the RISC Zero zkVM.

## Compiling the program

To compile the program, you will need to have the RISC Zero toolchain installed. Follow the [official instructions](https://dev.risczero.com/api/zkvm/install) to get the most up-to-date information.

To use RISC Zero, you'll need to compile with

```bash
cargo build --features risc0
```

The matching binary is `risc0-runner`.

Run `cargo risczero build` to build smart contract.

## Running the Collatz Conjecture program

Hylé smart contracts can be executed client-side, enabling strong decentralization and permissionlessness. 

To execute the smart contract, run the program with correct inputs.

### Generate a proof

#### Prove the transition from X to the next number

```sh
# Generate a proof of the transition from X to the next number in the Collatz conjecture
cargo run next X
# Or do it reproducibly
cargo run -- -r next X
```

Here are some concrete examples:

```sh
# Compute a proof of a transition between the number 12 and 6
cargo run next 12

# Compute a proof of a transition between the number 17 and 52
cargo run next 17
```

#### Reset to X

```sh
# Reset to X, assuming the current number is a 1
cargo run reset X
# Or do it reproducibly
cargo run -- -r reset X
```

Here is one concrete example:

```sh
# Compute a proof where the state of the contract is assumed to be 1, and the state should be reset to 31
cargo run reset 31
```

#### Invalid transitions

The Collatz smart contract demonstrates how the code of the smart contract enforces constraints on the state:

- You can't generate valid proofs of transition between numbers that are not part of the Collatz sequence.
- The contract will reject attempts to reset to 0, as there would no longer be any next state.

### Use the proof

Every time, a `proof.json` file containing the receipt will be generated. You can use this proof, along with the inputs, to trigger state transitions on Hylé. Read more: [Your first smart contract](../getting-started/your-first-smart-contract.md).

### Verify the proof

Coming next.
