# Data Availability

Hylé will provide self-sufficient permissionless data availability, but not necessarily data retrievability.

## How Hylé avoids the data availability problem

Hylé is a layer one blockchain, and will be decentralised in the future. As such, all validators and full nodes must have access to all data required to accept new blocks. There is therefore **no data availability problem for Hylé full nodes**.

They must however access the full proofs inside each block. Thankfully, because our proofs are proofs of state commitment transitions, they are rather lightweight by themselves.

### Light nodes

There are currently no light nodes in Hylé. In the mid- to long-term, blocks generation will become provable: light nodes will be able to rely on the block headers and proof of block, in the same way that full nodes do. There will be essentially no difference between light and full nodes.

Note however that the design of the chain is intended to make full nodes as lightweight as possible, so the need for light nodes is not as pressing as it is for other chains.

## Permissionless DA for smart contracts

Because the protocol only requires proofs of the transitions between state commitments, the full state-diff may be hidden. This is by design and enables privacy. <!-- TODO article on privacy -->

For smart contracts that intend to be permissionless, this can lead to DOS. In this case, the program must **force the proof to contain the full state-diff**.

If the proof contains the full state-diff, valid transactions sent to Hylé contain it too and external indexers are able to reconstruct the full state.

This solves the data availability problem, assuming that transaction data is available long enough for any honest indexer to reconstruct the full state. 

This is a rather weak assumption <!-- can we rephase this so that « weak assumption » is clearer--> and our plan is to provide between 7 and 28 days of guaranteed DA, like Ethereum blobs. <!-- TODO LINK https://ethereum.org/en/roadmap/danksharding/ --> 

## Data retrievability

Historical data is not provided by the protocol, as it is unnecessary to create new blocks. 

Starting a new node from scratch or reading past transactions for events may still be useful at times. To that end, Hylé nodes can be archive nodes which store the full state of the blockchain, including transactions, from the genesis block.

Our current plan is that Hylé will provide a full archive node.

### Proving past blocks

Ethereum provides no native way to easily verify whether a given block belongs to the chain. This prevents leveraging historical data in smart contracts.

Hylé blocks will, in the long term, contain the root of a merkle-mountain-range of all past blocks, allowing the generation of inclusion proofs of past blocks.
