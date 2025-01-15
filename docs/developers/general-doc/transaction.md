# Transactions on Hylé

On [traditional blockchains](./hyle-vs-vintage-blockchains.md),  users sign their transactions with a wallet and submit them to a node for block inclusion.

On Hylé, onchain operations are split into two distinct transactions:

- Blob transaction: describes the intended operation.
- Proof transaction: validates and executes the operation.

We cut these in two steps because ZK proofs take longer to generate than traditional signature.

Why two steps ? Because zkProof are not as fast to generate as traditional signatures. By sequencing your intent with a blob transaction, you can later update the state with a proof transaction after the proof is ready. For more details, read our [pipelined proving principles](./pipelined-proving.md).

Each proof transaction (unless using recursion) proves a single blob. If a blob transaction contains multiple blobs, a separate proof is needed for each blob.

Once all blobs are proven, the blob transaction is considered **settled**, and the states of the referenced contracts are updated.

## Example: token transfer

For a token transfer, a blob transaction contains two blobs:

- Identity blob: verifies the sender’s identity and authorizes the transfer.
- Transfer: executes the token transfer.

These two blobs require two corresponding proof transactions.

## Blob transaction structure

A **blob transaction** includes two key fields:

- An **identity** string. See [the dedicated page on identity](./identity.md).
- A list of **blobs**, each containing:
  - A **contract name** string.
  - A **data** binary field, which will be parsed by the contract.

For the token transfer example, the blob transaction looks like this:

```json
{
    "identity": "bob.hydentity",
    "blobs": [
        {
            "contract_name": "hydentity",
             // Binary data for the operation of hydentity contract
             // VerifyIdentity { account: "bob.hydentity", nonce: "2" }
            "data": "[...]" 
        },
        {
            "contract_name": "hyllar",
             // Binary data for the operation of hyllar contract
             // Transfer { recipient: "alice.hydentity", ammount: "20" }
            "data": "[...]"
        }
    ]
}
```

## Proof transaction structure

A Proof transaction is made of

- A **contract name** (string)
- The **proof data** (binary field), holding:
  - the ZK proof;
  - the smart contract output.

For Risc0 & SP1, the proof data's smart contract output is `HyleOutput`, as defined in the contract-sdk. It includes the following information:

- The **initial state** of the contract
- The **new state** of the contract
- The **identity** that made the operation
- A reference to the proven blob, composed of a **transaction hash** and an **index**
- Additional fields for proof validation, built by the SDK.

For the token transfer example, the two proofs will look like this:

```json
{
    "contract_name": "hydentity",
    // Binary proof, holding a HyleOutput with :
    // initial_state: the state of the contract "hydentity" 
    //    before the blob transaction execution 
    //    (nonce of bob is 1)
    // next_state: the state of the contract "hydentity" 
    //    after the blob transaction execution 
    //    (nonce of bob is 2)
    // identity: "bob.hydentity"
    // tx_hash: the above blob transaction hash 
    // index: 0
    "proof": "[...]"
}
```

and

```json
{
    "contract_name": "hyllar",
    // Binary proof, holding a HyleOutput with :
    // initial_state: the state of the contract "hyllar" 
    //    before the blob transaction execution 
    //    (balance of bob is 100 and alice is 0)
    // next_state: the state of the contract "hyllar" 
    //    after the blob transaction execution 
    //    (balance of bob is 80 and alice is 20)
    // identity: "bob.hydentity"
    // tx_hash: the above blob transaction hash 
    // index: 1
    "proof": "[...]"
}
```
