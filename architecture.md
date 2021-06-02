# Architecture CollabScore

Voici la spécification de l'architecture CollabScore, résumée globalement par la figure suivante qui décompose les fonctionnalités en modules. La couleur du cadre autour d'un module indique qu'il est sous la responsabilité du partenaire correspondant (cf légende).

![Architecture CollabScore](/figures/architecture.png)

## Le serveur CollabScore (Cnam)

Le Cnam met en place un serveur CollabScore constitué

 1. d'un dépôt de partitions multimodales
 2. d'une interface Web pour les interactions utilisateurs, 
 3.  et d'une interface de services REST pour les communications avec tous les modules développés par les autres partenaires du projet.

L'architecture à base de services permet à chaque partenaire de développer ses outils indépendamment, la seule contrainte technique étant
d'établir un canal de communication avec le serveur CollabScore via ses services.

### Les partitions multimodales

La notion de partition multimodale est centrale dans le projet (figure ci-dessus). Elle est basée sur la *partition pivot*, un codage de
la notation musicale décrivant le contenu d'une œuvre musicale (sous forme de notation) indépendamment des paramètres de présentation. 
En première approche on peut considérer qu'il s'agit d'un document MEI dépouillé autant que faire se peut de toute instruction de rendu.
Dans ce document les éléments notationels (éléments-pivots) relatifs au contenu (mesures, notes, silences et accords, métrique, altérations, peut-être liaisons) 
sont tous identifiables et donc référençables sous la forme d'IRI (cf. les propositions de l'IReMus [1]).
 
![Partition multimodale](/figures/partitionMM.png)

Une partition-pivot est issue d'une *source originale* (une image, scénario principal de CollabScore, mais on pourrait en toute généralité aussi considérer 
un document audio si on faisait de la transcription) à partir de laquelle son contenu est constitué par un processus de numérisation. 
Pour CollabScore, la source est une image provenant de la BnF ou de la Fondation Royaumont, et le processus est une combinaison d'OMR 
et de correction collaborative.

La partition-pivot est complétée par des annotations qui établissent des liens entre les éléments-pivot et des fragments de sources multimodales (images,
audio, vidéos, sources littéraire). La seule condition est que les fragments soient identifiables par une IRI, et que leur granularité 
corresponde à celle des éléments-pivot (en principe, la granularité sera la mesure).

# Références

[1]: https://github.com/Amleth/source-sherlockizer-service(Some technical thoughts on processing MEI sources to facilitate their future scholarly semantic annotation)
