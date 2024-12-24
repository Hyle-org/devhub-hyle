# Devnet

<!-- Testnet 
Hylé provides a testnet where you can test your smart contract and help us test our network.-->

Follow the instructions below to start building on Hylé by running a local devnet.

## Run your local devnet

### Recommended: Getting started with Docker

!!! failure
    We currently don't have a public Docker image available.

Follow these instructions to run a node, keeping in mind that this is unstable and can break with upcoming updates.

Download the Docker image:

```bash
docker pull ghcr.io/hyle-org/hyle:latest
```

Run the image:

```bash
docker run -v ./db:/hyle/data -e HYLE_RUN_INDEXER=false -p 4321:4321 -p 1234:1234 ghcr.io/hyle-org/hyle:latest
```

If you want to run with an indexer with `HYLE_RUN_INDEXER=true`, you will need a running PostgreSQL server. You can set it up with Docker:

```bash
# For default conf:
docker run -d --rm --name pg_hyle -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres
```

You can customize the db URL with `HYLE_DATABASE_URL`, with the default value being: `postgres://postgres:postgres@localhost:5432/postgres`.

### Build the Docker image locally

If you want to, you can rebuild the image locally from source:

```bash
docker build -t Hyle-org/hyle . && docker run -dit Hyle-org/hyle
```

### Alternative: Getting started from source

To start a single-node devnet (with consensus disabled), which is useful to build & debug smart contracts, run:

```bash
cargo build
HYLE_RUN_INDEXER=false cargo run --bin node
```

### Configuration

You can configure your setup using environment variables or by editing a configuration file.

<!--TODO Add table of what can be configured-->

#### Using environment variables

<!-- Corriger / compléter --->

Here's an example of how you can configure your setup using environment variables:

```bash
HYLE_RUN_INDEXER=false 
HYLE_CONSENSUS__SLOT_DURATION=100
```

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


##### Using a configuration file

To use a configuration file, copy the default settings where you run the node. If a file named config.ron is present, it will be automatically loaded by the node at startup.

If you're using Docker:

```bash
docker run -v ./db:/hyle/data -v ./config.run:/hyle/config.ron -e HYLE_RUN_INDEXER=false -p 4321:4321 -p 1234:1234 ghcr.io/hyle-org/hyle:latest
```

Then, whether you're using Docker or building from source:

```bash
# Copy default config where you run the node. If file named "config.ron" is present, it will be loaded by node at startup.
cp ./src/utils/conf_defaults.ron config.ron
```
