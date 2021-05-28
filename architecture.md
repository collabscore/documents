# Architecture CollabScore

Voici la spécification de l'architecture CollabScore, résumée globalement par la figure suivante qui décompose les fonctionnalités en modules. La couleur du cadre autour d'un module indique la responsabilité de chaque partenaire.

![Architecture CollabScore](/figures/architecture.png)

## Le serveur CollabScore (Cnam)

Le Cnam met en place un serveur CollabScore constitué

 1. d'un dépôt de partitions multimodales
 2. d'une interface Web pour les interactions utilisateurs, 
 3.  et d'une interface de services REST pour les communications avec tous les modules développés par les autres partenaires du projet.

L'architecture à base de services permet à chaque partenaire de développer ses outils indépendamment, la seule contrainte technique étant
d'établir un canal de communication avec le serveur CollabScore via ses services.

### Les partitions multimodales

![Partition multimodale](/figures/partitionMM.png)
