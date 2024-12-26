# Run your local devnet

<!-- Testnet 
Hylé provides a testnet where you can test your smart contract and help us test our network.-->

Follow the instructions below to start building on Hylé by running a local devnet. (Instructions for a testnet will be added when we launch it.)

## Recommended: Getting started with Docker

Follow these instructions to run a node, keeping in mind that this is unstable and can break with upcoming updates.

Download the Docker image:

```bash
docker pull ghcr.io/hyle-org/hyle:latest
```

Run the image:

```bash
docker run -v ./db:/hyle/data -e HYLE_RUN_INDEXER=false -e HYLE_REST=0.0.0.0:4321 -p 4321:4321 -p 1234:1234 ghcr.io/hyle-org/hyle:latest
```

If you run into an error, you may want to add the `--privileged` flag:

```bash
docker run --privileged -v ./db:/hyle/data -e HYLE_RUN_INDEXER=false -p 4321:4321 -p 1234:1234 ghcr.io/hyle-org/hyle:latest
```

If you want to run with an indexer with `HYLE_RUN_INDEXER=true`, you will need a running PostgreSQL server. You can set it up with Docker:

```bash
# For default conf:
docker run -d --rm --name pg_hyle -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres
```

You can customize the db URL with `HYLE_DATABASE_URL`, with the default value being: `postgres://postgres:postgres@localhost:5432/postgres` (see below for environment variables).

## Build the Docker image locally

If you want to, you can rebuild the image locally from source:

```bash
docker build -t Hyle-org/hyle . && docker run -dit Hyle-org/hyle
```

## Alternative: Getting started from source

To start a single-node devnet (with consensus disabled), which is useful to build & debug smart contracts, run:

```bash
cargo build
HYLE_RUN_INDEXER=false cargo run --bin node
```

## Configuration

You can configure your setup using environment variables or by editing a configuration file.

<!--TODO Add table of what can be configured-->

### Using environment variables

The variable always begins with `HYLE_`, followed by the variable: `HYLE_RUN_INDEXER=false`. Multi-level variables are chained together with a double `_`, eg. `HYLE_CONSENSUS__SLOT_DURATION=100`.

All variables can be customized on your single-node instance.

| Variable                   | Default value                                          | Description                                                                                                          |
|----------------------------|--------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| HYLE_ID                    | "node"                                                 | Node identifier in the consensus. Usage subject to change in future releases.                                        |
| HYLE_SINGLE_NODE           | true                                                   | Whether the network runs as a single node or with a multi-node consensus.                                            |
| HYLE_P2P_LISTEN            | true                                                   | The node should listen to new peer. Mandatory (true) if multi node consensus.                                        |
| host                       | "127.0.0.1:1231"                                       | host & port to listen for the P2P protocol                                                                           |
| peers                      | []                                                     | list of peers to connect to at startup to follow a running consensus                                                 |
| storage__interval          | 10                                                     | unused                                                                                                               |
| log_format                 | "full"                                                 | “json” or “full”                                                                                                     |
| rest                       | "127.0.0.1:4321"                                       | host & port for the rest api endpoint                                                                                |
| data_directory             | "data_node"                                            | directory name to store node state                                                                                   |
| database_url               | "postgres://postgres:postgres@localhost:5432/postgres" | PostgreSQL server address (necessary if you want to use an indexer).                                                 |
| consensus__slot_duration   | 1000                                                   | Duration between 2 blocks                                                                                            |
| consensus__genesis_stakers | {}                                                     | Map of stakers for the genesis block. Keys are all nodes “id”, and values are the stake amount for each one of them. |
| p2p__ping_interval         | 10                                                     | Interval the p2p layer does a ping to check aliveness of other peers.                                                |
| run_indexer                | true                                                   | Whether there should be an indexer.                                                                                  |
| da_address                 | "127.0.0.1:4141"                                       | host & port of the data availability module, that streams historical & new blocks. It might be used by indexers.     |

### Using a configuration file

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
