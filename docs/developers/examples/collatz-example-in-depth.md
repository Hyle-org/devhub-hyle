# Collatz example in depth

Hylé smart contracts can be written in any language that targets one of our [supported proving schemes](../general-doc/supported-proving-schemes.md).
To provide a simple example, we'll use the RISC Zero Collatz Conjecture program, which can be found [here](https://github.com/Hyle-org/collatz-conjecture).

The Collatz Conjecture is a simple mathematical problem that can be expressed as a program.  
The conjecture states that, for any positive integer `n`:

- if `n` is even, divide it by 2
- if `n` is odd, multiply it by 3 and add 1
- repeat this process, and you will eventually reach 1.

The program is implemented in rust, and compiles to the RISC Zero ZkVM.

## Compiling the program

To compile the program, you will need to have the RISC Zero toolchain installed.  
Follow the [official instructions](https://dev.risczero.com/api/zkvm/install) to get the most up-to-date information.

Once that is done, you should be able to run `cargo build`.

## Running the Collatz Conjecture program

Hylé smart contracts can be executed client-side, enabling strong decentralisation and permissionlessness.  
Executing the smart contract is thus as simple as running the program with the correct inputs.

```sh
# Compute a proof of a transition between the number 12 and 6
cargo run next 12

# Compute a proof of a transition between the number 17 and 52
cargo run next 17

# Compute a proof where the state of the contract is assumed to be 1, and the state should be reset to 31
cargo run reset 31
```

Every time, a `proof.json` file containing the receipt will be generated. You can use this proof, along with the inputs, to trigger state transitions on Hylé (see [Your first smart contract](../getting-started/your-first-smart-contract.md) for more details).

## Invalid transitions

The Collatz smart contract demonstrates how the code of the smart contract enforces constraints on the state.  
For example, you cannot generate valid proofs of transition between numbers that are not part of the Collatz sequence.  
The contract will also reject attempts to reset to 0, as there would no longer be any next state.
