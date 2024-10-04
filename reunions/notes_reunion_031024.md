# Notes réunion du 3 octobre 2024

## Interfaces de l'application collaborative

### Phase 2

L'intitulé choisi est "Contexte de lecture"

Démonstration de l'état intermédiaire par Sameh et discussion. On prendra en compte le degré de confiance dans la reconnaissance de l'élément de contexte (clé, armure, métrique) pour activer la widget de correction sur cet élément.

Il n'est pas envisagé pour le moment de pouvoir AJOUTER un élément dans la partition
En revanche il sera possible de SUPPRIMER
On pourra ausi ajouter une annotation pour signaler un problème non solvable

Actuellement le changement d'un élément (clé) entraîne un réaffichage par Verovio qui rompt l'alignement aveccla partition -> mettre en place un recalcul qui tient compte de l'édition validée par
l'utilisateur

### Phase 3: objets musicaux

**Correction des durées**. La voix la plus longue correspond à la métrique de la mesure. Sinon
une erreur est remontée

  - erreur globale à la mesure, dans tous les cas
  - erreur locale à l'objet musical si l'emplacement de l'erreur a pu être déterminé

Actuellement certains objets peuvent être supprimés par notre processus pour restreindre l'ipact des erreurs. Il faut faire mieux, en tirant parti du fait que Verovio semble capable d'afficher autant d'objets que l'on veut indépendamment de la métrique.

**Accords**: on peut zoomer sur les notes individuelles d'un accord pour modifier leurs propriétés. La modification de la durée s'applique à toutes les autres notes.

**Triolets** (et autre nuplets): ils ne sont pas systématiquement explicitement indiqués. Essayer d'améliorer  l'inférence automatique en fonction des ligatures et de l'alignement sur les autres voix.

Il faudra que l'interface permette la saisie d'une séquence d'objets (notes, silenes, accords) pour indiquer un nuplet.

## Interface AlgoMus

On peut visualiser la liste des sources audio et en sélectionner une.

## Royaumont

Les images de la Damoiselle élue doivent être triées en début de semaine prochaine
On attend dans la Dropbox les images des scènes choisies de Pelléas, ansi que les extraits de vidéos, et d'un audio (piano seul)

Organisation d'un workshop sur deux jours en mai ou juin: Royaumont nous proposera des dates.

