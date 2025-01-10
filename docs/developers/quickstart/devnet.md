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
docker run -v ./db:/hyle/data -p 4321:4321 ghcr.io/hyle-org/hyle:latest
```

If you run into an error, you may want to add the `--privileged` flag:

```bash
docker run --privileged -v ./db:/hyle/data -p 4321:4321 ghcr.io/hyle-org/hyle:latest
```

If you want to run with an indexer add the parameter `-e HYLE_RUN_INDEXER=true`, you will need a running PostgreSQL server. You can set it up with Docker:

```bash
# For default conf:
docker run -d --rm --name pg_hyle -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres
```

You can customize the db URL with `-e HYLE_DATABASE_URL`, with the default value being: `postgres://postgres:postgres@localhost:5432/postgres` (see below for environment variables).

## Build the Docker image locally

If you want to, you can rebuild the image locally from source:

```bash
docker build -t Hyle-org/hyle . && docker run -dit Hyle-org/hyle
```

You can now [create your first smart contract](./your-first-smart-contract.md).

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

All variables can be customized on your single-node instance.

| Variable                   | Default value                                        | Description                                                                                                          |
|----------------------------|------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| HYLE_ID                    | node                                                 | Node identifier in the consensus. Usage subject to change in future releases.                                        |
| HYLE_SINGLE_NODE           | true                                                 | Whether the network runs as a single node or with a multi-node consensus.                                            |
| HYLE_P2P_LISTEN            | true                                                 | Mandatory (true) if multi-node consensus. The node should listen to new peers.                                       |
| HYLE_HOST                  | 127.0.0.1:1231                                       | Host & port to listen for the P2P protocol.                                                                          |
| HYLE_PEERS                 | []                                                   | List of peers to connect to at startup to follow a running consensus.                                                |
| HYLE_STORAGE__INTERVAL     | 10                                                   | unused                                                                                                               |
| HYLE_LOG_FORMAT            | full                                                 | “full” or “json”                                                                                                     |
| HYLE_REST                  | 127.0.0.1:4321                                       | Host & port for the REST API endpoint.                                                                               |
| DATA_DIRECTORY             | data_node                                            | Directory name to store node state.                                                                                  |
| DATABASE_URL               | postgres://postgres:postgres @localhost:5432/postgres| PostgreSQL server address (necessary if you want to use an indexer).                                                 |
| CONSENSUS__SLOT_DURATION   | 1000                                                 | Duration between blocks.                                                                                             |
| CONSENSUS__GENESIS_STAKERS | {}                                                   | Keys are all nodes “id”, and values are the stake amount for each one of them. Map of stakers for the genesis block. |
| P2P__PING_INTERVAL         | 10                                                   | Interval the p2p layer does a ping to check aliveness of other peers.                                                |
| RUN_INDEXER                | true                                                 | Whether there should be an indexer.                                                                                  |
| DA_ADDRESS                 | 127.0.0.1:4141                                       | Host & port of the data availability module, which streams historical & new blocks. It might be used by indexers.    |

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

You can now [create your first smart contract](./your-first-smart-contract.md).
