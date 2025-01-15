# Transaction on Hylé

On traditional blockchains, you are used to sign your transaction with your wallet, and then sends 
it to a node to be included in a block. 

On Hyle, it is slightly different, as an operation on chain is made of 2 "transactions": 

- A **Blob transaction** describing the operation to be made.
- A **Proof transaction** that effectively do the operation.

Why two steps ? Because zkProof are not as fast to generate as traditional signatures. So you need to 
sequence your intent, and then given the sequenced operations, the state change can be proven. See [pipelined proving principles](../general-doc/pipelined-proving.md) for more details.

Basically a Proof transaction (unless when using recursion) prooves a single blob in a blob transaction.
Thus, when sending a Blob Transaction with 2 blobs, you will need to send 2 proofs.

Once all blobs are proven, the Blob Transaction is considered **settled**, and all referenced contract's states 
are updated.

## Example:
For a token transfer, you sends a blob transaction with 2 blobs:

- A blob to validate the identity of the sender, that allows the transfer
- A blob to effectively do the transfer

And then two proof transactions, to prove each blob.

## Blob transaction

In a more practical way a **Blob transaction** is made of 2 fields:

* An **identity** as a string. See [the dedicated page on identity](./identity.md).
* A list of **Blob** where each one is:
    * A **contract name** as a string 
    * A **data** as a binary field that can be parsed **by the contract**

So for the above example, you would have:
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

## Proof transaction

A Proof transaction is made of 

- A **contract name**
- The **proof data** as binary field

The proof data holds the zk proof, but also the output of the smart contract. 

For Risc0 & SP1, this output is a "HyleOutput" defined in the contract-sdk which holds trustable data:

- The **initial state** of the contract
- The **new state** of the contract 
- The **identity** that made the operation 
- A reference to the blob that is proven, composed of a **transaction hash** and an **index**
- And some other fields used for validation of the validity of the proof transaction. The sdk is in charge
of building these.

For the above example, the 2 proofs will look like :

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

