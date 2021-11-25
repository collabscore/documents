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

### Zones

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_zone.json",
  "title": "Schéma des coordonnées d'une zone sur une image (xmin ymin xmax ymax)",
  "type": "array",
  "minItems": 4,
  "maxItems": 4
}
```
On peut faire référence à un type, comme dans les types `Symbol` et `Element`.

### Symboles

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_symbol.json",
  "title": "Schéma de description d'un symbole",
  "type": "object",
  "properties": {
     "label": {"type": "string"},
     "zone": {"description": "Emprise du symbole", "$ref": "dmos_zone.json"}
   }
}
```
### Eléments

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_element.json",
  "title": "Schéma de description d'un élément",
  "type": "object",
  "properties": {
     "label": {"type": "string"},
     "zone": {"description": "Emprise de l'élément", "$ref": "dmos_zone.json"}
   }
}
```
D'autres types utilitaires sont donnés en fin de document: clef, armure, métrique.

### Structure d'un document

Le fragment de plus haut niveau indique que le document OMR s'applique à une partition-image, et que le résultat
est constitué d'un tableau de descripteurs de page, un
descripteur pour chaque page analysée. Le schéma d'un descripteur de page se trouve dans le fichier  ``dmos_page.json``.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/dmos_schema.json",
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
           "$ref": "dmos_page.json"
         },
         "minItems": 1
       }
    },
   "required": ["score_image_url", "date", "pages"],
  "additionalProperties": false
}
```

> Vérifié: DMOS traite bien plusieurs pages. Mais je n'ai pas trouvé mention du no de page dans la structure produite.

[Exemple d'un document JSON racine](http://collabscore.org/dmos/data/dmos_data.json)

### Pages, systèmes et mesures

Chaque page est constitué d'une entête (*à définir*) et d'une liste de systèmes. 

> Le type suivant correspond à `PartitionReco`.  

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_page.json",
  "title": "Schéma des descripteurs de page",
  "type": "object",
  "properties": {
     "no_page": { "type": "integer" },
     "header_systems": {
         "description": "Tableau des descripteurs de système",
         "type": "object",
         "properties": {
           "entete": {"description": "Infos d'entête de la page: à préciser", "type": "string"}
           }
      },
     "systems": {
            "description": "Tableau des systèmes",
            "type": "array",
            "items": {"$ref": "dmos_system.json"},
         "minItems": 1
       }
   },
   "required": ["no_page", "header_systems"],
  "additionalProperties": false
}
```

> Question: détecte-t-on que les portées sont groupées entre elles de manière hiérarchique (piano, ou bois / vents / cordes dans l'orchestre, etc.)

[Exemple du composant JSON représentant une page](http://collabscore.org/dmos/data/page_1.json)

Un système est composé d'un ou plusieurs entêtes, un pour chaque portée, et d'une liste de mesures.

> Correspond au type `SystPorteeReco`.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_system.json",
  "title": "Schéma des descripteurs de système",
  "type": "object",
  "properties": {
      "id" : {"description": "Numéro du système", "type": "integer"},
     "zone": {"description": "Zone du système dans la page","$ref": "dmos_zone.json"},
    "headers": {
         "type": "array",
         "description" : "Description des portées du système",
          "items": {"$ref": "dmos_staff_header.json" }
    },
    "measures": {
         "type": "array",
         "description" : "Une système est une séquence de mesures",
         "items": {"$ref": "dmos_measure.json" }
    }
  },
   "required": ["id", "zone", "headers", "measures"],
  "additionalProperties": false
}
```
Le type des descripteurs de portée (correspondant à `ExtGPorteeReco`) est ci-dessous:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_staff_header.json",
  "title": "Schéma de la description d'un portée de système",
  "type": "object",
    "properties": {
       "id_staff": {"$type": "integer" },
       "first_bar": {"$ref": "dmos_element.json" }
   }
}
```

[Exemple du composant JSON représentant un système avec trois portées](http://collabscore.org/dmos/data/system_1_1.json)

### Mesures 

> Ce type correspond à `SystMesureReco`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://collabscore.org/dmos_measure.json",
  "title": "Schéma des descripteurs de mesure",
  "type": "object",
  "properties": {
     "zone": {
               "description": "Zone de la mesure dans le système",
               "$ref": "https://collabscore.org/dmos_zone.json"
     },
    "headers": {
         "type": "array",
         "description" : "Entêtes, un pour chaque portée.",
          "items": {"$ref": "https://collabscore.org/dmos_measure_header.json" }
    },
    "voices": {
         "type": "array",
         "description" : "Une mesure est une séquence de voix",
         "items": {"$ref": "https://collabscore.org/dmos_voice.json" }
    }
  }
}
```


[Exemple du composant JSON représentant une mesure avec trois portées (première mesure du premier système de la première page)](http://collabscore.org/dmos/data/measure_1_1_1.json)

> Question: que se passe-t-il si on a un changement de clé dans une mesure

## Voix

Finalement une voix (dans une mesure) est une séquence d'éléments de voix. Elle peut passer d'une portée à une autre.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_voice.json",
  "title": "Schéma des descripteurs de voix",
  "type": "object",
  "properties": {
    "elements": {
         "type": "array",
         "description" : "Une voix est une séquence d'éléments de voix",
         "items": {"$ref": "dmos_element_voice.json" } 
    }
  }
}
```
### Elément de voix:

> Ce type correspond à `ElemVoix`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_element_voice.json",
  "title": "Schéma des éléments de voix",
  "type": "object",
  "properties": {
    "type": {"description": "Elément ou symbole",
          "anyOf": [{"$ref": "dmos_element.json"}, {"$ref": "dmos_symbol.json"}]},
    "no_step": {"description": "Numéro de pas", "type": "integer"},
    "no_group": {"description": "A expliquer", "type": "integer"},
    "duration": {"description": "Codification à clarifier", "type": "number"},  
    "step_duration": {"description": "A expliquer", "type": "number"},
    "direction": {"description": "Haut ou bas?", "type": "string"},
    "att_note": { "$ref": "dmos_att_note.json"},
    "att_rest": { "$ref": "dmos_att_rest.json"},
    "att_clef": { "$ref": "dmos_att_clef.json"},
    "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }}
  },
   "required": ["type", "no_step", "duration"],
  "additionalProperties": false
}
```


[Exemple du composant JSON représentant une voix de la première mesure du premier système de la première page](http://collabscore.org/dmos/data/voice_111_1.json)

> Question: est-il nécessaire de communiquer les informations sur les pas ?

### Attributs des notes et des silences

> Ce type correspond à `AttNot`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_att_note.json",
  "title": "Schéma des attributs de note",
  "type": "object",
  "properties": {
    "nb_heads": {"description": "Nombre de têtes", "type": "integer"},
    "heads": {"type": "array", "items": { "$ref": "dmos_note.json" }},
    "articulations_top": {"type": "array", "items": { "$ref": "dmos_symbol.json" }},
    "articulations_bottom": {"type": "array", "items": { "$ref": "dmos_symbol.json" }},
    "directions": {"description": "nuances et autres symboles", "type": "array", 
        "items": { "$ref": "dmos_symbol.json" }},
    "other_objects": {"type": "array", "items": { "$ref": "dmos_element.json" }},
    "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }}
  }
}
```

> Question: peut-on obtenir une info de plus haut niveau sur les symboles  (savoir que c'est un fa# par exemple)

> Question: sait-on distinguer les liaisons d'articulations (slurs) et celles qui prolongent une note (tie)

Ce type correspond à `AttRest`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_att_rest.json",
  "title": "Schéma des attributs de note",
  "type": "object",
  "properties": {
    "nb_heads": {"description": "Nombre de têtes", "type": "integer"},
    "heads": {"type": "array", "items": { "$ref": "dmos_note.json" },
    "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }
  }
}
```
> Nbb: le no de porté semble déjà faire partie de `TeteR`

> Question: les paroles éventuelles sont-elles reconnues

## Schéma des types de base

### Tête de note

> Correspond au type `TeteR`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_note.json",
  "title": "Schéma de la description d'une note",
  "type": "object",
  "properties": {
     "head_symbol": {"description": "Noire, blanche, etc.", "$ref": "dmos_symbol.json"},
     "no_staff": {"description": "Numéro de portée", "type": "integer"},
     "height": {"description": "Hauteur de la note sur la portée", "type": "integer"},
     "alter": {"description": "Altération", "$ref": "dmos_symbol.json"},
     "tied": {"description": "Liée à la note précédente ? À clarifier", "type": "boolean"},
     "errors": {"description": "Liste des erreurs", 
                "type": "array",
                "items": { "$ref": "dmos_error.json" }
     }
   },
   "required": ["head_symbol", "no_staff", "height", "errors"],
  "additionalProperties": false
}
```
> Question : des informations comme le nb et la liste de points doivent-elles être exportées ?

### Clef

> Correspond au type `CleR`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_clef.json",
  "title": "Schéma de la description d'une clef",
  "type": "object",
  "properties": {
     "symbol": {"description": "Code du symbole", "$ref": "dmos_symbol.json"},
     "id_staff": {"description": "Numéro de portée", "type": "integer"},
     "height": {"description": "Hauteur de la clef sur la portée", "type": "integer"},
     "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }
     }
   },
   "required": ["symbol", "id_staff", "height", "errors"],
  "additionalProperties": false
}
```

### Armure

> Correspond au type `ArmR`


```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_key_signature.json",
  "title": "Schéma de la description d'une armure",
  "type": "object",
  "properties": {
     "element": {"description": "dièse, bémol ou aucun", "type": "string"},
     "nb_naturals": {"description": "Nombre de bécarres", "type": "integer"},
     "nb_alterations": {"description": "Nombre d'altérations", "type": "integer"},
     "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }
     }
   },
   "required": ["element", "nb_flats", "nb_alterations", "errors"],
  "additionalProperties": false
}
```

### Chiffrage métrique

> Correspond au type `ChiR`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_time_signature.json",
  "title": "Schéma de la description d'une métrique",
  "type": "object",
  "properties": {
     "element": {"description": "type du chiffrage", "type": "string"},
     "time": {"description": "Nb de temps", "type": "integer"},
     "unit": {"description": "Unité de temps", "type": "integer"},
     "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }
     }
   },
   "required": ["element", "time", "unit", "errors"],
  "additionalProperties": false

```

> Question type du chiffrage à préciser


### Entete de portée

Une portée peut être simple ou double (ou  même triple -- orgue ?)

> Correspond au type `Entete'

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_system_header.json",
  "title": "Schéma de la description d'un entête de portée",
  "type": "object",
  "properties": {
     "clef": {"$ref": "dmos_clef.json" },
     "key_signature": {"$ref": "dmos_key_signature.json" },
     "time_signature": {"$ref": "dmos_time_signature.json" }
   }
}
```


