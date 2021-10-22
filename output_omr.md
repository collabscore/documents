# Syntaxe des documents JSON donnant le résultat d'une reconnaissance optique

Hypothèses sur l'entrée: 
 
  - c'est un PDF, découpé en pages
  - l'OMR donne le résultat pour l'ensemble des pages
  - chaque page contient un fragent de partition constitué de plusieurs systèmes

L'OMR produit en sortie un document JSON contenant toutes les informations collectées, et structuré selon
le schéma détaillé ci-dessous.

## Schéma de la sortie JSON

La spécification s'appuie sur la syntaxe des schémas JSON (https://json-schema.org/). Elle est découpée
en fragments pour plus de lisibilité. Chaque fragment définit un type de donnée particulier, et peut être référencer
ou référencer d'autres fragments.

À titre d'exemple, voici le fragment décrivant les coordonnées d'un rectangle.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_zone.json",
  "title": "Schéma des coordonnées d'une zone sur une image",
  "type": "object",
  "properties": {
     "x_min": {
          "description": "Abcisse inférieure",
          "type": "integer"
        },
     "y_min": {
          "description": "Ordonnée inférieure",
          "type": "integer"
        },
     "x_max": {
          "description": "Abcisse supérieure",
          "type": "integer"
        },
     "y_max": {
          "description": "Ordonnée supérieure",
          "type": "integer"
        }
   }
}
```

### Structure d'un document

Le fragment de plus haut niveau indique que le document OMR s'applique à une partition-image, et que le résultat
est constitué d'un tableau de descripteurs de page, un
descripteur pour chaque page analysée. Le schéma d'un descripteur de page se trouve dans le fichier  ``omr_pages.json``.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/schema_omr.json",
  "title": "Schéma des documents de sortie OMR",
  "type": "object",
  "properties": {
     "score_image_url": {
          "description": "URL de la partition-image analysée",
          "type": "string"
        },
     "date" : {
          "description": "Date de l'analyse",
          "type": "string"
        },  
     "pages": {
         "description": "Tableau des descripteurs de page",
         "type": "array",
         "items": {
           "$ref": "https://collabscore.org/omr_page.json"
         },
         "minItems": 1
       }
    }
}
```

> Vérifier que l'OMR traite bien plusieurs pages.

### Pages, systèmes et portées

Chaque page est constitué d'une liste de systèmes, et chaque système comprend plusieurs portées

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_pages.json",
  "title": "Schéma des descripteurs de page",
  "type": "object",
  "properties": {
     "no_page": { "type": "integer" },
     "systems": {
         "description": "Tableau des descripteurs de système",
         "type": "object",
         "properties": {
           "zone": {
               "description": "Zone du système dans la page",
                "$ref": "https://collabscore.org/omr_zone.json"
           },
          "staves": {
            "description": "Tableau des descripteurs de portée",
            "type": "array",
            "items": {
                      "$ref": "https://collabscore.org/omr_staff.json"
                   },
                }
            },
            "minItems": 1
          }
       }
    }
}
```

> Question: détecte-t-on que les portées sont gropées entre elles (piano, ou bois / vents / cordes dans l'orchestre, etc.)

Une portée comprend un entête et un tableau de voix

> Question: j'ai l'impression que dans la version dont je dispose, on découpe d'abord un système en mesure, puis chaque mesure en portée. Est-il possible de faire l'inverse 
> pour obtenir la séquence des mesures d'une portée ? 

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_staff.json",
  "title": "Schéma des descripteurs de portée",
  "type": "object",
  "properties": {
     "zone": {
               "description": "Zone de la portée dans le système",
               "$ref": "https://collabscore.org/omr_zone.json"
     },
    "headers": {
         "type": "array",
         "description" : "Préciser les informations qui peuvent être trouvées dans l'entête d'une portée"
    },
    "measures": {
         "type": "array",
         "description" : "Une portée est une séquence de mesures",
         "items": {"$ref": "https://collabscore.org/omr_measure.json" }
    }
  }
}
```

### Mesures et voix

NB: la mesure ici est considérée pour une seule portée.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_measure.json",
  "title": "Schéma des descripteurs de mesure",
  "type": "object",
  "properties": {
     "zone": {
               "description": "Zone de la mesure dans la portée",
               "$ref": "https://collabscore.org/omr_zone.json"
     },
    "headers": {
         "type": "array",
         "description" : "Préciser les informations qui peuvent être trouvées dans l'entête d'une mesure"
    },
    "voices": {
         "type": "array",
         "description" : "Une mesure est une séquence de voix",
         "items": {"$ref": "https://collabscore.org/omr_voice.json" }
    }
  }
}
```

> Question: que se passe-t-il si on a un changement de clé dans une mesure

Finalement une voix (dans une mesure) est une séquence de symboles.

> Question: déjà rencontré le cas d'une voix qui passe d'une portée à une autre (assez fréquent, surtout au clavier)


```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_voice.json",
  "title": "Schéma des descripteurs de voix",
  "type": "object",
  "properties": {
    "voices": {
         "type": "array",
         "description" : "Une voix est une séquence de symboles",
         "items": {
            "type": "object",
            "properties": {
              "description": "À préciser,
              "zone": {"$ref": "https://collabscore.org/omr_zone.json" }
            }
         }
    }
  }
}
```

> Question: peut-on obtenir une info de plus haut niveau sur les symboles  (savoir que c'est un fa# par exemple)
