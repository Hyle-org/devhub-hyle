# CLI Installation instructions

Hylé is currently using the Cosmos SDK as a base, and the CLI provides both a way to interact with the chain, and a way to start the devnet.

Clone the [Hylé Cosmos repository](https://github.com/Hyle-org/hyle-cosmos) and install it.

## Mac, Linux, Windows with WSL

You will need to have installed `make` and `go`, v1.20 and above, on your system.

Here are the commands:

```bash
git clone https://github.com/Hyle-org/hyle-cosmos.git
cd hyle
make build # or make install
```

You can then get a list of commands with `hyled help`.

### Setting up the CLI

Running the following command will setup your CLI and reset the local blockchain data if any.

```bash
make init
```

### Running a devnet

Run:

```bash
./hyled start
```

Your node should start from block 0. Note that it persists data in a folder named `hyled-data` in the current working directory by default.
