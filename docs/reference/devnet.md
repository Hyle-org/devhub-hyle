# Devnet configuration

## Recommended: Run from source

For a single-node devnet (consensus disabled) with an indexer, clone the [hyle repository](https://github.com/Hyle-org/hyle) and run:

```sh
cargo run -- --pg
```

This command starts a temporary PostgreSQL server and erases its data when you stop the node.

### Optional: Persistent storage

For persistent storage, start a standalone PostgreSQL instance:

```bash
# Start PostgreSQL with default configuration:
docker run -d --rm --name pg_hyle -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres
```

Then, navigate to the Hylé root and run:

```bash
cargo run
```

## Alternative: Start with Docker

Use Docker to run a local node. Note that the devnet is unstable and may break with future updates.

### Pull the Docker image

```bash
docker pull ghcr.io/hyle-org/hyle:v0.12.1
```

### Run the Docker container

```bash
docker run -v ./data:/hyle/data -p 4321:4321 ghcr.io/hyle-org/hyle:v0.12.1
```

If you run into an error, try adding the `--privileged` flag:

```bash
docker run --privileged -v ./data:/hyle/data -p 4321:4321 ghcr.io/hyle-org/hyle:v0.12.1
```

To run with an indexer, add the parameter `-e HYLE_RUN_INDEXER=true` and set up a running PostgreSQL server with Docker:

```bash
docker run -d --rm --name pg_hyle -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres
```

And the node linked to it:

```bash
docker run -v ./data:/hyle/data \
    -e HYLE_RUN_INDEXER=true \
    -e HYLE_DATABASE_URL=postgres://postgres:postgres@pg_hyle:5432/postgres \
    --link pg_hyle \
    -p 4321:4321 \
    ghcr.io/hyle-org/hyle:v0.7.2
```

You can now [create your first smart contract](./example/first-token-contract.md).

!!! tip
    To reset your devnet, delete the ./data folder and restart from Step 1. Otherwise, you risk re-registering a contract that still exists.

## Alternative: Build the Docker image locally

If you prefer to build the image from source, run:

```bash
docker build -t Hyle-org/hyle . && docker run -dit Hyle-org/hyle
```

## Configuration

<!--Put on docs.rs when we'll be ready.-->
You can configure your setup using environment variables or by editing a configuration file.

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
| HYLE_DATA_DIRECTORY             | data_node                                            | Directory name to store node state.                                                                                  |
| HYLE_DATABASE_URL               | postgres://postgres:postgres @localhost:5432/postgres| PostgreSQL server address (necessary if you want to use an indexer).                                                 |
| HYLE_CONSENSUS__SLOT_DURATION   | 1000                                                 | Duration between blocks.                                                                                             |
| HYLE_CONSENSUS__GENESIS_STAKERS | {}                                                   | Keys are all nodes “id”, and values are the stake amount for each one of them. Map of stakers for the genesis block. |
| HYLE_P2P__PING_INTERVAL         | 10                                                   | Interval the p2p layer does a ping to check aliveness of other peers.                                                |
| HYLE_RUN_INDEXER                | true                                                 | Whether there should be an indexer.                                                                                  |
| HYLE_DA_ADDRESS                 | 127.0.0.1:4141                                       | Host & port of the data availability module, which streams historical & new blocks. It might be used by indexers.    |

### Using a configuration file

To load settings from a file, place `config.ron` in your node's working directory. It will be detected automatically at startup.

For Docker users, mount the config file when running the container:

```bash
docker run -v ./data:/hyle/data -v ./config.run:/hyle/config.ron -e HYLE_RUN_INDEXER=false -p 4321:4321 -p 1234:1234 ghcr.io/hyle-org/hyle:v0.12.1
cp ./src/utils/conf_defaults.ron config.ron
```

For source users, copy the default config template:

```bash
cp ./src/utils/conf_defaults.ron config.ron
```
