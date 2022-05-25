# Architecture CollabScore

Voici une proposition pour l'architecture CollabScore, résumée globalement par la figure suivante qui décompose les fonctionnalités en modules. La couleur du cadre autour d'un module indique qu'il est sous la responsabilité du partenaire correspondant (cf. légende).

![Architecture CollabScore](/figures/architecture.png)

## Le serveur CollabScore (Cnam)

Le Cnam met en place un serveur CollabScore constitué

 1. d'un dépôt de partitions multimodales
 2. de fonctionnalités internes développées par le Cnam visant notament à permettre la réconciliation de corrections collaboratives
 3. d'une interface Web pour les interactions utilisateurs, 
 4. et d'une interface de services REST pour les communications avec tous les modules développés par les autres partenaires du projet.

L'architecture à base de services permet à chaque partenaire de développer ses outils indépendamment, la seule contrainte technique étant
d'établir un canal de communication avec le serveur CollabScore via ses services.

Le serveur sera réalisé en Python avec le framework Django. Indépendamment du format interne, les échanges via les services se feront en JSON pour les méta-données, en MEI pour la notation musicale. L'utilisation du MEI permettra d'exploiter les capacités de Verovio (http://verovio.org) en terme de visualisation, interaction, édition.

### Les partitions multimodales

La notion de partition multimodale est centrale dans le projet (figure ci-dessus). Elle est basée sur la *partition pivot*, un codage de
la notation musicale décrivant le contenu d'une œuvre musicale (sous forme de notation) indépendamment des paramètres de présentation. 
En première approche on peut considérer qu'il s'agit d'un document MEI dépouillé autant que faire se peut de toute instruction de rendu. Le Cnam fournira
une spécification précise prochainement.

Dans ce document les éléments notationels (éléments-pivots) relatifs au contenu (mesures, notes, silences et accords, métrique, altérations, peut-être liaisons) 
sont tous identifiables et donc référençables sous la forme d'IRI (cf. les propositions de l'IReMus [1]).
 
![Partition multimodale](/figures/partitionMM.png)

Une partition-pivot est issue d'une *source originale* (une image, scénario principal de CollabScore, mais on pourrait en toute généralité aussi considérer 
un document audio si on faisait de la transcription) à partir de laquelle son contenu est constitué par un processus de numérisation. 
Pour CollabScore, la source originale est une image provenant de la BnF ou de la Fondation Royaumont, et le processus est une combinaison d'OMR 
et de correction collaborative.

### Les annotations

La partition-pivot est complétée par des annotations qui établissent des liens entre les éléments-pivot et des fragments de sources multimodales (images,
audio, vidéos, sources littéraire). La seule condition est que les fragments soient identifiables par une IRI, et que leur granularité 
corresponde à celle des éléments-pivot (en principe, la granularité sera la mesure).

Les annotations seront conformes au modèle du W3C. En particulier, les services REST de CollabScore permettront de déposer / récupérer les annotations
au format JSON-LD.

## Interface (UI) d'alignement entre une partition-image et le pivot (IReMus, fin 2021)

Cette interface permettra de lier les boites englobantes (bounding-box ou BB) des mesures sur une partition-image et la partition-pivot. Elle interrogera le serveur
CollabScore pour obtenir la partition-pivot et l'URL d'une source-image, calculera l'ensemble des liens entre une BB de mesure et 
l'élément correspondant dans la partition-pivot, et enverra l'ensemble de ces liens sous forme d'annotation au serveur CollabScore.

Il serait sans doute très utile de récupérer des outils existants ([3],[4]).

### Pour spéficier une région sur une image

La norme à suivre est (?) celle du IIIF. Elle est décrite ici https://iiif.io/api/image/3.0/#41-region. Les paramètres pour la boîte englobante sont le coin supérieur gauche de la boîte, la hauteur et la largeur. On y ajouter deux paramètres: la taille (utiliser *max*), la rotation (utiliser 0) et enfin la qualité (utiliser default) le format (par exemple jpg).

Exemple pour une image d'URL *imgurl*: *<imgurl>/125,15,120,140/max/0/default.jpg*.

**Faut-il un serveur IIIF ?**. Pas nécessairement, on peut simplement utiliser les paramètres pour situer la région sur une image et surimposer un calque. Avantage du serveur IIIF: on peut extraire une mesure individuellement. Intérêt ? Peut-être dans le cadre de l'annotation collaborative. À voir.
 
En résumé: une BB est décrite par l'URL de l'image, les coordonnées du rectangle, et les trois autres paramètres (optionnels,  ou valeurs par défaut).

 ### Annotation liant la partition-pivot et une BB

 On va suivre la recommandation du W3C (https://www.w3.org/TR/annotation-model/).
 
 On part du principe que l'annotation qualifie une mesure d'une partition. Au sens du W3C, la mesure est donc la *cible* (*target*)
 de l'annotation, et l'adresse de la BB est le *corps* (*body*) de l'annotation. 
 
    - pour *target*, on utilise l'adressage IIIF décrit ci-dessus
    - pour *corps*, il faut simplement l'URL du document MEI de la partition, et le *xml:id* de la mesure annotée.
 
 Pour obtenir une représentation du corps à intégrer dans une annotation JSON_LD,  on peut utiliser la recommandation XPointer (https://www.w3.org/TR/xptr-framework/). La syntaxe serait donc par exemple ``mapartition.mei#xpointer(id('m-57'))``
 
 Voici un exemple de ce que peut être la représentation JSON-LD de l'annotation (avec qq attributs optionnels comme l'auteur, dates de création
 et modoification).

```json
{
  "@context": "http://www.w3.org/ns/anno.jsonld",
  "id": "http://example.org/anno1",
  "type": "Annotation",
  "creator": "createur",
  "created": "2021-01-28",
  "modified": "2021-05-29",
  "body": "http://serveurIIIF/imgdir/12,50,90,56/max/0/default.jpg",
  "target": "http://collabscore/mapartition.mei#xpointer(id('m-57'))"
}
```
 
### Aspects techniques
 
Du point de vue des outils, le scénario privilégié est le suivant. Dans une interface HTML on met en vis-à-vis la source-image, et la visualisation Verovio de la partition-pivot, enrichie avec des ancres permettant de sélectionner une mesure. Il reste à encadrer la mesure correspondante sur l'image, et à valider l'association, ce qui correspond tecnhiquement à l'appel au service REST du serveur CollabScore. 
 
## Interface (UI) d'alignement entre un audio ou vidéo et le pivot (Cnam, mi-2022)

L'idée est la même mais cette fois il faut associer à chaque mesure de la partition-pivot un fragment (période) d'un document audio ou d'une vidéo. Il
est possible / probable qu'il existe déjà des procédures d'alignement automatique.
 
Voir la librairie Vues.js
 

**TODO**: essayer de reprendre contact avec Antescofo, sinon étudier l'état de l'art.

## Interface (UI) de synchronisation des sources (Cnam + BnF, fin 2022)

Via la partition-pivot, il sera possible de mettre en correspondance deux sources quelconques. 

   - une source-image et le pivot lui-même (affiché sous forme de partition)
   - une source-image et un document audio (dont, cas particulier, un MIDI produit à partir du pivot)
   - une source-image et une vidéo

Une interface doit permettre une synchronisation de deux sources quelconques. Les scénarios:

  - source image à gauche, partition-pivot à droite. Tout défilement ou action sur l'un (par exemple déclenchement
    d'une écoute MIDI sur la partition pivot) entraîne un alignement avec l'autre (p.e. surlignage des mesures sur l'image).
  - source image à gauche, audio à droite. L'écoute de l'audio entraîne le surlignage des mesures sur l'image
  - même scénario avec un document vidéo à droite.

Le serveur CollabScore fournit la séquence des annotations appariées: pour chaque élément-pivot (mesure), le fragment de la
source A et le fragment de la source B. L'interface doit assurer visuellement l'alignement.

Le Cnam doit réaliser cette interface, mais en vue d'une intégration facile dans Gallica. La BnF dispose d'un petit financement
pour l'adaptation selon les normes IIIF.

**TODO**: 

  - cas des sources littéraires à étudier
  - concertation avec la BnF sur les choix techniques

## Le module OMR (IRISA, toute la durée du projet)

Le module OMR est à peu près entièrement à la charge de l'IRISA. Le principe de l'intégration au reste de 
l'architecture est le suivant: le module OMR interroge le serveur CollabScore pour obtenir des partitions multimodales.
Pour chacune, la source originale peut être récupérée par URL, traitée par l'OMR, avec production d'une partition
pivot (document MEI) et sans doute des annotations indiquant les parties à confirmer ou contrôler. 

La partition pivot et les annotations sont transmises au serveur CollabScore via les services REST.

**TODO**:
  
   - Proposition très générale, à vérifier dans le détail
   - Question: obtiendra-t-on automatiquement les liens entre BB de la source-origine et les éléments-pivot ?
   - Concertation avec l'IRISA sur les détails techniques

## UI correction collaborative (Cnam)

Module à la charge du Cnam. A creuser.

# Références

[1]: https://github.com/Amleth/source-sherlockizer-service(Some technical thoughts on processing MEI sources to facilitate their future scholarly semantic annotation)
[2]: https://www.w3.org/TR/annotation-model/(Web annotation data model)
[3]: https://www.audiolabs-erlangen.de/resources/MIR/2019-ISMIR-LBD-Measures(Démo d'un outil pour oîtes englobantes, ISMIR)
[4]: https://dl.acm.org/doi/10.1145/3429743(Schubert Winterreise Dataset: A Multimodal Scenario for Music Analysis)
[5]: https://gitlab.com/algomus.fr/dezrann/(Dezrann, l'interface d'annotation AlgoMus)

