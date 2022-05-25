# Syntax of JSON document output par DMOS

Hypothèses sur l'entrée: 
 
  - c'est un PDF, découpé en pages
  - l'OMR donne le résultat pour l'ensemble des pages
  - chaque page contient un fragment de partition constitué de plusieurs systèmes

L'OMR produit en sortie un document JSON contenant toutes les informations collectées, et structuré selon
le schéma détaillé ci-dessous.

## Schéma de la sortie JSON

La spécification s'appuie sur la syntaxe des schémas JSON (https://json-schema.org/). Elle est découpée
en fragments pour plus de lisibilité. Chaque fragment définit un type de donnée particulier, et peut être référencé
ou référencer d'autres fragments. Le découpage en fragments suit celui de l'annexe C de la thèse de Bertrand (le nom du type est signalé).   

À titre d'exemple de type JSON, voici le fragment décrivant les coordonnées d'un rectangle.

### Régions

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_region.json",
  "title": "Schéma des coordonnées d'une région sur une image (x y w h)",
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
     "region": {"description": "Emprise du symbole", "$ref": "dmos_region.json"}
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
     "region": {"description": "Emprise de l'élément", "$ref": "dmos_region.json"}
   }
}
```
D'autres types utilitaires sont donnés en fin de document: clef, armure, métrique.

### DMOS document structure

The schema of DMOS documents is contained in ``dmos_schema.json``, and the schema of a page descriptor is in 
``dmos_page.json``.

```json
{
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "dmos-schema.json",
    "type": "object",
  "title": "Schema of DMOS documents",
  "description": "A DMOS document is a list of pages, with one descriptor for each page.",
  "properties": {
     "score_image_url": {
          "description": "URL of the analyzed score-image",
          "type": "string"
        },
     "date" : {
          "description": "Date of image analysis",
          "type": "string"
        },  
     "pages": {
         "description": "Array of page descriptors",
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
[Example of a DMOS document root](http://collabscore.org/dmos/data/dmos_ex1.json)

### Pages, systems and measures

#### Page

Each page consists in a header (*structure to be defined*) and a list of systems. 

> From type `PartitionReco`.  

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_page.json",
  "title": "Schema of page descriptor",
  "description": "Each page consists in a header (*structure to be defined*) and a list of systems",
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
            "description": "Array of systems ",
            "type": "array",
            "items": {"$ref": "dmos_system.json"},
         "minItems": 1
       }
   },
   "required": ["no_page", "header_systems", "systems"],
  "additionalProperties": false
}
```


[Example of a page descriptor](http://collabscore.org/dmos/data/page1.json)

#### System 

> From type `SystPorteeReco`.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_system.json",
  "title": "Schema of system descriptor",
  "description": "Each system is a list of headers, one for each staff, and a list of measures",
  "type": "object",
  "properties": {
      "id" : {"description": "Numéro du système", "type": "integer"},
     "region": {"description": "Région du système dans la page","$ref": "dmos_region.json"},
    "headers": {
         "type": "array",
          "items": {"$ref": "dmos_staff_header.json" }
    },
    "measures": {
         "type": "array",
         "items": {"$ref": "dmos_measure.json" }
    }
  },
   "required": ["id", "zone", "headers", "measures"],
  "additionalProperties": false
}
```
#### Staff descriptor

> Form type `ExtGPorteeReco`


> Important: there might be a hierarchical grouping of staves in a system.  (piano, strings / winds / organ / etc.) At some
> point, a staff belongs to a "part", i.e., the sub-score assigned to a single performer. There might be one (usually),
> 2 or even 3 staves (organ), and the voices played by the performed can (in the most complex case) be distribued 
> over all the staves of its part. **Thus**, I added the ``id_part`` to the staff descriptor to indicate
> the part a staff belongs to. As an inital approx., we can assume that staff = part.

Schema ``dmos_staff_header``. 

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_staff_header.json",
  "title": "Staff descriptor",
  "type": "object",
    "properties": {
       "id_part": {"$type": "string" },
       "no_staff": {"$type": "integer" },
       "first_bar": {"$ref": "dmos_element.json" }
   },
   "required": [ "id_part", "no_staff", "first_bar"],
  "additionalProperties": false
}
```

[Example of a system with three staves](http://collabscore.org/dmos/data/page1_s1.json)

#### Measures

> From type `SystMesureReco`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_measure.json",
  "title": "Schema of measure descriptor",
  "type": "object",
  "properties": {
     "region": {
               "description": "Région of the measure",
               "$ref": "dmos_region.json"
     },
    "headers": {
         "type": "array",
         "description" : "Headers, one for each staff",
          "items": {"$ref": "dmos_measure_header.json" }
    },
    "voices": {
         "type": "array",
         "description" : "A measure is  list of voices",
         "items": {"$ref": "dmos_voice.json" }
    }
  }
}
```

[Example of a measure over three staves  (first staff, first system, first page)](http://collabscore.org/dmos/data/page1_s1_m1.json)

## Voice

A voice (in  a measure) is a sequence of voice elements, which each belongs to one of the staves of the voice's part.

> Important: j'ai ajouté id_part, pour savoir à quelle partie appartient une voix. En principe une voix ne peut évoluer
> que sur les portées de sa partie. Dans un premier temps, on peut se contenter d'assimiler partie et portée.
> J'ai aussi ajouté l'identifiant de la voix (à engendrer)

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_voice.json",
  "title": "Schema of voice descriptor",
  "description": "A voice (in  a measure) is a sequence of voice elements, which each belongs to one of the staves of the voice's part.",
  "type": "object",
  "properties": {
    "id" : {"description": "Id of the voice", "type": "string"},
    "id_part" : {"description": "Id of the part the voice belongs to", "type": "string"},  
    "elements": {
         "type": "array",
         "items": {"$ref": "dmos_element_voice.json" } 
    },
   "required": ["id", "id_part","elements"],
  "additionalProperties": false
  }
}
```
### Voice elements

> From `ElemVoix`. 

> Important: representation of durations must be revised (float = clumsy parsing)
 
> Important: there can probably be other stuff than notes, rests of clefs. To be investigated

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_element_voice.json",
  "title": "Schema of voice elements",
  "description": "A voice element is a symbol that can appear as part of a voice in a measure. Either a note, a rest or a clef",
  "type": "object",
  "properties": {
    "type": {"description": "Elément ou symbole",
          "anyOf": [{"$ref": "dmos_element.json"}, {"$ref": "dmos_symbol.json"}]},
    "no_step": {"description": "Numéro de pas", "type": "integer"},
    "no_group": {"description": "A expliquer", "type": "integer"},
    "duration": { "$ref": "dmos_duration.json"},
    "step_duration": {"description": "A expliquer", "type": "number"},
    "direction": {"description": "Haut ou bas?", "type": "string"},
    "att_note": { "$ref": "dmos_att_note.json"},
    "att_rest": { "$ref": "dmos_att_rest.json"},
    "att_clef": { "$ref": "dmos_clef.json"},
    "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }}
  },
   "required": ["type", "no_step", "duration"],
  "additionalProperties": false
}
```


[Example: first page, first system, first measure, first part, voice 1](http://collabscore.org/dmos/data/page1_s1_m1_p1_v1.json)

> Question: do we need of the details on steps?

### Notes and rest attributes

> From `AttNote`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_att_note.json",
  "title": "Schema of note attributes",
  "description": "A note consists of several heads, directions and other symbols",
  "type": "object",
  "properties": {
    "nb_heads": {"description": "Nombre de têtes", "type": "integer"},
    "heads": {"type": "array", "items": { "$ref": "dmos_note_head.json" }, "minItems": 1},
    "articulations_top": {"type": "array", "items": { "$ref": "dmos_symbol.json" }},
    "articulations_bottom": {"type": "array", "items": { "$ref": "dmos_symbol.json" }},
    "directions": {"description": "nuances et autres symboles", "type": "array", 
        "items": { "$ref": "dmos_symbol.json" }},
    "other_objects": {"type": "array", "items": { "$ref": "dmos_element.json" }},
    "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }}
  },
   "required": ["nb_heads", "heads"],
  "additionalProperties": false
}
```

> Question: can we distinguish slurs from ties ?

> From `AttRest`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_att_rest.json",
  "title": "Schema of rest attributes",
  "description": "A rest consists of several heads",
  "type": "object",
  "properties": {
    "nb_heads": {"description": "Nb heads", "type": "integer"},
    "heads": {"type": "array", "items": { "$ref": "dmos_note_head.json" }, "minItems": 1},
     "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }}
  },
   "required": ["nb_heads", "heads"],
  "additionalProperties": false
}
```
> Note: the staff number os already in `TeteR`

> Question: what about lyrics ?

## Schéma des types de base

### Durée

Duration = a fraction of a beat

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_duration.json",
  "title": "Schéma de la description d'une durée musicale",
  "type": "object",
  "properties": {
     "numer": {"description": "Numérateur", "type": "integer"},
     "denom": {"description": "Dénominateur", "type": "integer"}
     },
   "required": [ "numer", "denom"],
  "additionalProperties": false
}

### Note head

> From type `TeteR`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_note_head.json",
  "title": "Schema of note head descriptor",
  "description": "A note head on a staff, with an optional accidental", 
  "type": "object",
  "properties": {
     "head_symbol": {"description": "Noire, blanche, etc.", "$ref": "dmos_symbol.json"},
     "no_staff": {"description": "Numéro de portée", "type": "integer"},
     "height": {"description": "Hauteur de la note sur la portée", "type": "integer"},
     "alter": {"description": "Altération", "$ref": "dmos_symbol.json"},
     "nb_points": {"description": "Nbre de points", "type": "integer"},
     "tied": {"description": "Liée à la note précédente ? À clarifier", "type": "boolean"},
     "errors": {"description": "Liste des erreurs", 
                "type": "array",
                "items": { "$ref": "dmos_error.json" }
     }
   },
   "required": ["head_symbol", "no_staff", "height"],
  "additionalProperties": false
}
```
> Question : do we need the number of points ?

### Clef

> From type `CleR`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_clef.json",
  "title": "Schéma de la description d'une clef",
  "type": "object",
  "properties": {
     "symbol": {"description": "Code du symbole", "$ref": "dmos_symbol.json"},
     "no_staff": {"description": "Numéro de portée", "type": "integer"},
     "height": {"description": "Hauteur de la clef sur la portée", "type": "integer"},
     "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }
     }
   },
   "required": ["symbol", "no_staff", "height", "errors"],
  "additionalProperties": false
}
```

### Armure

> Correspond au type `ArmR`
> 
> Important: ne faudrait-il pas indiquer le no de la portée?


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
   "required": ["element", "nb_naturals", "nb_alterations", "errors"],
  "additionalProperties": false
}
```

### Chiffrage métrique

> Correspond au type `ChiR`
> Important: ne faudrait-il pas indiquer le no de la portée?

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


### Entete de mesure

> From type `Entete'

> Important: I added the staff number, common to the clef, key and meter (only appeared with the clef in Bertrand)

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_measure_header.json",
  "title": "Schema of measure headers (clef, key, meter, on a specific staff)",
  "type": "object",
  "properties": {
      "no_staff": {"type": "integer"},
     "clef": {"$ref": "dmos_clef.json" },
     "key_signature": {"$ref": "dmos_key_signature.json" },
     "time_signature": {"$ref": "dmos_time_signature.json" }
   },
   "required": ["no_staff"],
  "additionalProperties": false
}
```

# Pending issues

 #. We need to codify errors, and error representation
 #. When a new system is met, it is crucial to identify the continuity of staves, otherwise we cannot obtain the proper sequence of measures
 
 

