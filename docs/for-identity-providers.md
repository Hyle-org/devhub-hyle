# Hylé for Identity Providers

Hylé does not specify what an "account" is, or even what identity particularly means. This gives it hitherto unheard of flexibility in handling identity, including:
- EOAs like Ethereum native wallets
- Smart accounts of any kind
- Regular web2 identity
- Passports & other national identity documents.

!!! note
    You are entering TODO area, none of this is currently implemented.

The way identity is handled on Hylé relies simply on the caller contract in a multicall.
When a user crafts a transaction, their first call should be a proof-of-identity, for example a call to the native `/eth` smart contract, which validates Ethereum-like EOA signatures.
Any subsequent call can see that the user is indeed the owner of some `/eth` address, e.g. `0xfoobar/eth`, and can use that address name trustlessly.

### Registering your own stateless identity provider
There are two components to a stateless identity provider such as the Ethereum EOA smart contract:
- A smart contract registered on Hylé, authenticating proofs
- A client-side library that can craft proofs

See the _Ethereum EOA smart contract_ for an example of such a provider.

### Adding support for your smart wallet

TODO: the general idea here is that we need access to some state where smart contracts are registered (e.g. the starknet state), and can craft proofs in a similar way. The data is public, so this remains permissionless.

### Registering a stateful, private identity provider

This can be used by [games](for-zk-apps.md), SSO providers, or any other use-case that needs to handle user identity in a more traditional way.

TODO: the gist here is to actually use ZK, and create valid proofs that nonetheless do not reveal the inner details of the authentication, merely that a given user is indeed who they claim they are. The on-chain contract needs access to a valid state commitment.
