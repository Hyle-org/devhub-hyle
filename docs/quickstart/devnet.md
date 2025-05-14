# Run your local devnet

For a single-node devnet (consensus disabled) with an indexer, clone the [hyli repository](https://github.com/hyli-org/hyli) and run:

```sh
cargo run -- --pg
```

This command starts a temporary PostgreSQL server and erases its data when you stop the node.

For alternative setups, optional features, and advanced configurations, check out [the devnet reference page](../reference/devnet.md).
