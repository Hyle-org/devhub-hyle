# Data Availability

Hylé will provide self-sufficient permissionless data availability, but not necessarily data retrievability.

## How hylé avoids the data availability problem

Hylé is a layer one blockchain, and will be decentralised in the future. As such, all validators and all full nodes must have access to all data required to accept new blocks. There is therefore no data availability problem for Hylé full nodes themselves.

They must however have access to the full proofs in each block. Thankfully, because our proofs are proofs of state commitment transitions, they are rather lightweight by themselves.

### Light nodes

There are currently no light nodes in Hylé. In the mid/long-term, blocks generation will become provable and thus light nodes will be able to rely on the block headers + proof of block - in the very same way that full nodes do, and there will be essentially no difference between the two.
Note however that the design of the chain is intended to make full nodes as lightweight as possible, so the need for light nodes is not as pressing as it is for other chains.

## Permissionless DA for smart contracts

Because the protocol only requires proofs of transitions between state commitments, there is a possibility that the full state-diff is hidden. This is by design and enables privacy. <!-- TODO article on privacy -->

However, this can lead to DOS for smart contracts that intend to be permissionless. In this case, the program itself must force the proof to contain the full state-diff.  
This way, valid transactions sent to Hylé will contain the full state-diff, and external indexers can reconstruct the full state, thus solving the data availability problem. THis, of course, assumes that transaction data is available long enough for any honest indexer to reconstruct the full state. This is a rather weak assumption and the plan here is to provide between 7 and 28 days of guaranteed DA, like Ethereum blobs. <!-- TODO LINK -->

## Data retrievability

Historical data is not provided by the protocol, as it is unnecessary to create new blocks. However, starting a new node from scratch, or reading past transactions for events could still be useful. To that end, Hylé nodes can be archive nodes, which store the full state of the blockchain, including transactions, from the genesis block.

The plan is currently that Hylé will provide a full archive node.

### Proving past blocks

Ethereum provides no native way to easily verify wether a given block belongs to the chain. This prevents leveraging historical data in smart contracts. Hylé blocks will, in the long term, contain the root of a merkle-mountain-range of all past blocks, allowing the generation of inclusion proofs of past blocks.
