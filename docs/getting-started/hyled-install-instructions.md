# CLI Installation instructions

The simplest way to interact with Hylé is using `hyled`, the cosmos-SDK powered CLI.

Clone the [Hylé repository](https://github.com/Hyle-org/hyle) and install it.

## Mac, Linux, Windows with WSL

You will need to have installed `make` and `go`, v1.20 and above, on your system.

Here are the commands:
```bash
git clone https://github.com/Hyle-org/hyle.git
cd hyle
make build # or make install
```

You can then get a list of commands with `hyled help`.

<!--TODO: write some additional useful commands here-->

### Creating an account

Hylé currently still requires Cosmos SDK accounts to sign transactions. You can create one with the following command:

```bash
hyled keys add name-of-the-key
hyled keys show name-of-the-key # To see the actual cosmos SDK address
```

### Running a devnet

Run:

```bash
make init # This resets the blockchain data
./hyled start
```

Your node should start from block 0. Note that it persists data in a folder named `hyled-data` in the current working directory by default.
