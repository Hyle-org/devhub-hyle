# Identity management

## Where is identity relevant on Hylé?

One blob transaction on Hylé includes:

- Blobs, as many as wanted;
- One blob which corresponds to the identity of the person who initiated the transaction.

Note that:

- Every blob transaction requires a single identity.
- All provable blobs within a transaction must share the same identity.

Any contract can be an identity. Hylé ships [a native `hydentity` contract](https://github.com/Hyle-org/hyle/tree/main/contracts/hydentity), but you can use any source as an identity proving scheme.

## What's special about identity on Hylé

Any smart contract can be an identity provider, and there is true interoperability: a transaction can send Hylé tokens from your Metamask wallet to an email and password account seamlessly.

## Implementation

!!! note
    Please contact us directly to know more about identity management on Hylé. We are aiming to publish implementation instructions in January 2025.

<!--
### You can use any source of identity

Un contrat d'identité sur Hylé peut venir de n'importe où : t'as pas un wallet Hylé. sur ETH t'utilises ta clé privée, etc. : on abstrait ça, tu prouves ton ID avec n'importe quel contrat du moment que le contrat de transfert accepte ton contrat d'identité.
A contract can impose a given identity, but doesn't _need_ to: I can say that a .google is as valid as a .skibidi
Montrer que n'importe quel contrat d'identité fonctionnera avec n'importe quel contrat

identités qui cohabitent : mon adresse gmail peut envoyer des tokens à ton passeport !

On envoie une preuve par blob. Dans le Hyle_output de chaque preuve, on va donner une identité, qui sera vérifiée avec le blob. (C'est donné en input de la preuve, et la preuve la ressort en output : ça prouve qu'elle a été donnée en input.)

Register + login : deux fonctions. Globalement : tu fais ton contrat comme tu veux, mais le plus simple c'est register + verify.

Il faut le nonce (mais les gnes de la blockchain comprennent) pour éviter les replay attack.
-->