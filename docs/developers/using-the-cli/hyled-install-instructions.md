# CLI Installation instructions

The CLI provides both a way to interact with the chain, and a way to start the devnet.

## Getting Started with Cargo

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

### Configuration 

You can configure your setup using environment variables or by editing a configuration file.

#### Using a configuration file

To use a configuration file, copy the default settings where you run the node. If a file named config.ron is present, it will be automatically loaded by the node at startup.

```bash
# Copy default config where you run the node. If file named "config.ron" is present, it will be loaded by node at startup.
cp ./src/utils/conf_defaults.ron config.ron
```

#### Using a configuration file

Here's an example of how you can configure your setup using environment variables:

```bash
HYLE_RUN_INDEXER=false 
HYLE_CONSENSUS__SLOT_DURATION=100
```

## Getting Started with Docker

### Build the Docker image locally

To build the Docker image locally, use:

```bash
  docker build . -t hyle
```

### Run locally with Docker

To run the Hylé node with Docker, use the following command:

```bash
  docker run -v ./db:/hyle/data -e HYLE_RUN_INDEXER=false -p 4321:4321 -p 1234:1234 hyle
```

If you encounter permission errors when accessing the /hyle/data volume, try adding the "--privileged" cli flag to the Docker command.