# Syntaxe des documents JSON donnant le résultat d'une reconnaissance optique

Hypothèses sur l'entrée: 
 
  - c'est un PDF, découpé en pages
  - l'OMR donne le résultat pour l'ensemble des pages
  - chaque page contient un fragent de partition constitué de plusieurs systèmes

L'OMR produit en sortie un document JSON contenant toutes les informations collectées, et structuré selon
le schéma détaillé ci-dessous.

## Schéma de la sortie JSON

La spécification s'appuie sur la syntaxe des schémas JSON (https://json-schema.org/). Elle est découpée
en fragments pour plus de lisibilité.

Le fragmet de plus haut niveau indique que le document OMR est constitué d'un tableau de descripteurs de page, un
descritpeur pour chaque page analysée.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/schema_omr.json",
  "title": "Schéma des documents de sortie OMR",
  "type": "object",
  "pages": {
      "description": "Tableau des descripteurs de page",
      "type": "array",
      "items": {
        "type": "string"
      },
      "minItems": 1
    }
}
```



