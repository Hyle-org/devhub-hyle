# Identity management

## Where is identity relevant on Hylé?

One blob transaction on Hylé includes:

- Blobs, as many as wanted;
- One blob which corresponds to the identity of the person who initiated the transaction.

Note that:

- Every blob transaction requires a single identity.
- All provable blobs within a transaction must share the same identity.

Any contract can be an identity. Hylé ships [a native `hydentity` contract](https://github.com/Hyle-org/hyle/tree/main/contracts/hydentity), but you can use any source as an identity proving scheme.

## Identity verification in blob proofs





// Trash

Chaque blob tx a son identité.
Tous les provable blobs doivent avoir la même identité (identités égales), c'est ce qui garantit que tous les blobs sont bien validés par la même personne et qu'on n'ait pas de blob clandestin. L'identité des blobs est donnée par la preuve pour ces blobs.
Il en faut au moins un dont le contract name est le suffixe de l'identité qui est dans le blob : ça permet au blob de transfert de ne pas du tout se poser la question de l'identité. Il sait que l'identité a forcément été vérifiée parce que le contrat est signé par alice.identity (contrat de vérification de l'identité), le contract.name sera identity.
(On pourra avoir un alice.openpassport, alice.apple parce que zkTLS sur l'esapce client apple, …) 

On envoie une preuve par blob. Dans le Hyle_output de chaque preuve, on va donner une identité, qui sera vérifiée avec le blob. (C'est donné en input de la preuve, et la preuve la ressort en output : ça prouve qu'elle a été donnée en input.)


Plus besoin d'identity pour RunResult pour le sdk
Qlq checks sur les blobTx pour garantir qu'une identity est bien formée (<id.contrat_name>)
Quand on recoit une ProvedTx, si identity du HyleOutput est different de celui de la BlobTx on rejete
Au moment de settle une transaction, si on trouve pas de blob pour le contract_name, on refuse


Pas sûr d’avoir suivi, on permet de changer ‘identity’ entre les différents blob d’une même TX du coup?
non au contraire
avant le fix dans HyleOutput::identity on mettait le résultat de caller() et donc dans le cas d'une tx d'amm on avait bob.hydentity pour les 2 premières proof et amm pour les 2 suivantes...