# Syntaxe des documents JSON donnant le résultat d'une reconnaissance optique

Hypothèses sur l'entrée: 
 
  - c'est un PDF, découpé en pages
  - l'OMR donne le résultat pour l'ensemble des pages
  - chaque page contient un fragent de partition constitué de plusieurs systèmes

L'OMR produit en sortie un document JSON contenant toutes les informations collectées, et structuré selon
le schéma détaillé ci-dessous.

## Schéma de la sortie JSON

La spécification s'appuie sur la syntaxe des schémas JSON (https://json-schema.org/). Elle est découpée
en fragments pour plus de lisibilité. Chaque fragment définit un type de donnée particulier, et peut être référencé
ou référencer d'autres fragments. Le découpage en fragments suit celui de l'annexe C de la thèse de Bertrand (le nom du type est signalé).   

À titre d'exemple de type JSON, voici le fragment décrivant les coordonnées d'un rectangle.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_zone.json",
  "title": "Schéma des coordonnées d'une zone sur une image",
  "type": "object",
  "properties": {
     "x_min": {"description": "Abcisse inférieure", "type": "integer"},
     "y_min": {"description": "Ordonnée inférieure", "type": "integer"},
     "x_max": {"description": "Abcisse supérieure", "type": "integer"},
     "y_max": {"description": "Ordonnée supérieure", "type": "integer"}
   }
}
```

D'autres types utilitaires sont donnés en fin de document: clef, armure, métrique.

### Structure d'un document

Le fragment de plus haut niveau indique que le document OMR s'applique à une partition-image, et que le résultat
est constitué d'un tableau de descripteurs de page, un
descripteur pour chaque page analysée. Le schéma d'un descripteur de page se trouve dans le fichier  ``omr_pages.json``.

> Le type suivant correspond à 'PartitionReco`.

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

> Vérifié: DMOS traite bien plusieurs pages. Mais je n'ai pas trouvé mention du no de page dans la structure produite.

### Pages, systèmes et mesures

Chaque page est constitué d'une entête (*à définir*) et d'une liste de systèmes. 

> Le type suivant correspond à `PartitionReco`.  

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
           "entete": {"description": "Infos d'entête de la page: à préciser", "type": "object"},
          "systems": {
            "description": "Tableau des descripteurs de systèmes",
            "type": "array",
            "items": {"$ref": "https://collabscore.org/omr_system.json"},
          },
          "minItems": 1
       }
    }
}
```

> Question: détecte-t-on que les portées sont groupées entre elles de manière hiérarchique (piano, ou bois / vents / cordes dans l'orchestre, etc.)

Un système est composé d'un ou plusieurs entêtes, un pour chaque portée, et d'une liste de mesures.

> Correspond au type `SystPorteeReco`.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_system.json",
  "title": "Schéma des descripteurs de système",
  "type": "object",
  "properties": {
      "id" : {"description": "Numéro du système", "type": "integer"},
     "zone": {"description": "Zone du système dans la page","$ref": "https://collabscore.org/omr_zone.json"},
    "headers": {
         "type": "array",
         "description" : "Description des portées du système",
          "items": {"$ref": "https://collabscore.org/omr_system_header.json" }
    },
    "measures": {
         "type": "array",
         "description" : "Une système est une séquence de mesures",
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
            "type":  {"$ref": "https://collabscore.org/omr_error.json" } 
         }
    }
  }
}
```

> Question: peut-on obtenir une info de plus haut niveau sur les symboles  (savoir que c'est un fa# par exemple)
> Question: les paroles éventuelles sont-elles reconnues
> Question: sait-on distinguer les liaisons d'articulations (slurs) et celles qui prolongent une note (tie)


## Schéma des types de base

### Clef

> Correspond au type `CleR`


```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_clef.json",
  "title": "Schéma de la description d'une clef",
  "type": "object",
  "properties": {
     "symbol": {"description": "Code du symbole", "type": "string"},
     "no": {"description": "Numéro de portée", "type": "string"},
     "height": {"description": "Abcisse supérieure", "type": "integer"},
     "errors": {"description": "Liste des erreurs", 
                "type": "array",
                "items": { "$ref": "https://collabscore.org/omr_error.json" }
     }
   }
}
```
### Armure

> Correspond au type `ArmR`


```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/omr_key_signature.json",
  "title": "Schéma de la description d'une armure",
  "type": "object",
  "properties": {
     "element": {"description": "dièse, bémol ou aucun", "type": "string"},
     "nb_flats": {"description": "Nombre de bécarres", "type": "integer"},
     "nb_alter": {"description": "Nombre d'altérations", "type": "integer"},
     "errors": {"type": "array", "items": { "$ref": "https://collabscore.org/omr_error.json" }
     }
   }
}
```

### Chiffrage métrique

### Entete de portée

> Correspond au type `Entete'




(portée double -- piano ou  même triple -- orgue)( liste de portées. 
