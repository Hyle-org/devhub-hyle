# Devnet

<!-- Testnet 
Hylé provides a testnet where you can test your smart contract and help us test our network.
-->

You can start building on Hylé by running a local devnet by following the instructions below.

## Run your own single-node devnet

### Getting Started with Docker

!!! failure
    We currently don't have a deployment file available.

Follow these instructions to run a node, keeping in mind that this is unstable and can break with upcoming updates.

Download the Docker image:

```bash
docker pull europe-west3-docker.pkg.dev/hyle-413414/hyle-docker/hyle:main
```

Run the image:

```bash
docker run -v ./db:/hyle/data -e HYLE_RUN_INDEXER=false -p 4321:4321 -p 1234:1234 europe-west3-docker.pkg.dev/hyle-413414/hyle-docker/hyle:main
```

### Build the Docker image locally

If you want to, you can rebuild the image locally from source:

```bash
docker build -t Hyle-org/hyle . && docker run -dit Hyle-org/hyle
```

### Getting Started with Cargo

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

##### Using a configuration file

To use a configuration file, copy the default settings where you run the node. If a file named config.ron is present, it will be automatically loaded by the node at startup.

```bash
# Copy default config where you run the node. If file named "config.ron" is present, it will be loaded by node at startup.
cp ./src/utils/conf_defaults.ron config.ron
```

Here's an example of how you can configure your setup using environment variables:

```bash
HYLE_RUN_INDEXER=false 
HYLE_CONSENSUS__SLOT_DURATION=100
```

##### Environment variables

This is the default configuration for a node. All variables can be customized on your single-node instance.

```ron
Config(
  id: "node",
  single_node: true,
  p2p_listen: true,
  host: "127.0.0.1:1231",
  peers: [],
  storage: Storage(
    interval: 10
  ),
  log_format: "full",
  rest: "127.0.0.1:4321",
  data_directory: "data_node",
  database_url: "postgres://postgres:postgres@localhost:5432/postgres",
  consensus: Consensus (
    slot_duration: 1000,
    // Has to be empty as config is additive
    genesis_stakers: {}
  ),
  p2p: (
    ping_interval: 10
  ),
  run_indexer: true,
  da_address: "127.0.0.1:4141"
)
```
