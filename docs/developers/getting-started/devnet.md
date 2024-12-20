# Devnet

Hylé provides a devnet so you can develop your contracts and test them locally.

## Before you begin

Default nodes include the [`hydentity` contract](https://github.com/Hyle-org/hyle/tree/main/contracts/hydentity), a basic identity provider.

They also include `hyllar`, a simple ERC20-like contract, and `amm`, a simple AMM contract, which you can use as [examples](../examples/index.md)

Here are some useful links:

- Explorer / Indexer: [Hyléou](https://hyleou.hyle.eu/). Read more [about the explorer](https://docs.hyle.eu/developers/explorer/)
- [Your first smart contract](./your-first-smart-contract.md)
- [Examples](../examples/index.md)

## Run your local devnet

### Getting started with Docker

<!-- TODO: Lancelot to make image public -->
<!-- TODO: Alex S. to test run -->

To build the Docker image locally, use:

```bash
  # Pull image
  docker pull europe-west3-docker.pkg.dev/hyle-413414/hyle-docker/hyle:main
  # Run
  docker run -v ./db:/hyle/data -e HYLE_RUN_INDEXER=false -p 4321:4321 -p 1234:1234 hyle
```

!!! tip
  If you encounter permission errors when accessing the /hyle/data volume, try adding the "--privileged" cli flag to the Docker command.


### Run a node

We currently don't have a deployment file available.

Follow these instructions to run a node, keeping in mind that this is unstable and can break with upcoming updates.

Download the Docker image:

```bash
docker pull europe-west3-docker.pkg.dev/hyle-413414/hyle-docker/hyle:main
```

Then run the image:

```bash
docker run --name [container_name] -d [options] europe-west3-docker.pkg.dev/hyle-413414/hyle-docker/hyle:main
```

And rebuild the node from the source:

```bash
docker build -t Hyle-org/hyle . && docker run -dit Hyle-org/hyle
```

### Getting started with Cargo

To start a single-node devnet (with consensus disabled), which is useful to build & debug smart contracts, run:

```bash
cargo build
HYLE_RUN_INDEXER=false cargo run --bin node
```

If you want to run with an indexer, you will need a running PostgreSQL server. You can set it up with Docker:

```bash
# For default conf:
docker run -d --rm --name pg_hyle -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres
```

#### Configuration

You can configure your setup using environment variables or by editing a configuration file.

<!--TODO Add table of what can be configured-->

##### Using a configuration file

To use a configuration file, copy the default settings where you run the node. If a file named config.ron is present, it will be automatically loaded by the node at startup.

```bash
# Copy default config where you run the node. If file named "config.ron" is present, it will be loaded by node at startup.
cp ./src/utils/conf_defaults.ron config.ron
```

##### Using environment variables

Here's an example of how you can configure your setup using environment variables:

```bash
HYLE_RUN_INDEXER=false 
HYLE_CONSENSUS__SLOT_DURATION=100
```
