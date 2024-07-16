# Vibe Check

## Context

The general idea is to give people « good vibes » NFTs for smiling.

The step-by-step process:

1. I take a selfie where I’m smiling to generate a proof of my shiny, bubbly personality.
2. Vibe Check has trained a machine-learning model with some Python libraries. The Hylé team has transformed this model into a Cairo program.
3. I send my selfie to this Cairo program, which is ran in a virtual machine in-browser (Cairo VM compiled in WASM) or remotely (compiled as a binary), for better performance.
4. The machine-learning model checks that I am smiling. If I am, it generates a Cairo proof. 
5. Hylé verifies the proof, and a smart contract awards me an NFT to congratulate me for my good vibes. Since Hylé’s state is checkpointed on different networks, I could get an NFT on any bridged network, like Hylé itself, Starknet, or even Ethereum.

Watch [Sylve's demo at ETHCC[7]](https://ethcc.io/archive/The-rise-of-truthful-applications)!

## How it works

✨ Coming soon ✨

