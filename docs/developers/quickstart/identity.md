# Identity management

## Where is identity relevant on Hylé?

One blob transaction on Hylé includes:

- Blobs, as many as wanted;
- One blob which corresponds to the identity of the person who initiated the transaction.

Note that:

- Every blob transaction requires a single identity.
- All provable blobs within a transaction must share the same identity.

Any contract can be an identity. Hylé ships [a native `hydentity` contract](https://github.com/Hyle-org/hyle/tree/main/contracts/hydentity), but you can use any source as an identity proving scheme.

## Implementation

!!! note
    Please contact us directly to know more about identity management on Hylé. We are aiming to publish implementation instructions in January 2025.