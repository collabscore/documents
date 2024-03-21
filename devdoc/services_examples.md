# Exemples d'appels de services

Tout part de la connaissance d'une référence à un corpus ou un opus Neuma. Dans ce qui suit

  - le corpus est all:collabscore:saintsaens-ref 
  - l'opus est all:collabscore:saintsaens-ref:C006_0

## Services sur le corpus

  - Infos sur le corpus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref/
  - Liste des opus du corpus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref/_opera/

## Services sur l'opus et ses sources

  - Infos sur l'opus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/
  - Les sources de l'opus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/
  - Une source particulière, par exemple "iiif": https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/iiif/
  - Le fichier d'une source: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/iiif/_file/
  - Le manifeste d'une source (seulement pour les sources IIIF): https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/iiif/_manifest/

Voir la doc pour les services de création / mise à jour

## Annotations

 - Résumé des annotations sur un opus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/_stats/
 - Résumé des annotations pour un modèle particulier (ici, image-region): https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/_stats/
 - Toutes les annotations pour un modèle: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/_all/
 - Annotations pour un modèle particulier:
 
    - les mesures sur portée: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/measure-region/
    - les mesures sur système: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/mstaff-region/
  
   
