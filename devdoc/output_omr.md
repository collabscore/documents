# Syntax of JSON document output par DMOS

DMOS produces a JSON document that encodes all the collected information.

  - music notation: all data that constitute the music score and belong to the music notation language
  - geometric information: points, regions and segments that locate the notation symbols in the analyzed image
  - errors and questions: annotation on parts of the image that raise problems

## Schema of the JSON output

The specification below is based on JSON schemas (https://json-schema.org/). For readability reasons, it
is split in small fragments, each describing a specific data type. Fragments can refer others. 

The types  descriptions follows the principles of Annex 3 in Bertrand's thesis (the type nalme given there
is referred to in the following).

## Geometric types

As a first example, here is the JSON type for (2D) points. The type describes an array of exactly 
2 integer  values.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_point.json",
  "title": "A point = a pair of coordinates",
  "type": "array",
  "items": {"type": "integer" },
  "minItems": 2,
  "maxItems": 2
}
```

A segment is a pair of points (note the reference to the above ``Point``type).
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_segment.json",
  "title": "A segment  described by its two endpoints",
   "type": "array",
  "items": {"$ref": "dmos_point.json" },
  "minItems": 2,
  "maxItems": 2  
  }
```
A region is described by its contour (at least three points).

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_region.json",
  "title": "A region = a polygon described by its contour",
  "type": "array",
  "items": {"$ref": "dmos_point.json" },
  "minItems": 3
}
```
On peut faire référence à un type, comme dans les types `Symbol` et `Element`.

## Symboles

A symbol is a name, associated to an (optional) region.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_symbol.json",
  "title": "Symbol description",
  "type": "object",
  "properties": {
     "label": {"type": "string"},
     "region": {"$ref": "dmos_region.json"}
   },
   "required": ["label"],
  "additionalProperties": false
}
```
> Important: the list of recognized labels is given in the ``symbol.md`` document. 

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
     "id" : {
          "description": "Unique id of this score",
          "type": "string"
        },  
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
   "required": ["id", "score_image_url", "date", "pages"],
  "additionalProperties": false
}
```
[Example of a DMOS document root](http://collabscore.org/dmos/data/ex1/dmos_ex1.json)

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
     "page_url": { "type": "string",  "description":  "URL of the page image" },
     "no_page": { "type": "integer" },
     "header_systems": {
         "description":  "Array of systems descriptors",
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


[Example of a page descriptor](http://collabscore.org/dmos/data/ex1/page1.json)

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
      "id" : {"description": "System id", "type": "integer"},
     "region": {"description": "Region covered by the system in the page","$ref": "dmos_region.json"},
    "headers": {
         "type": "array",
          "items": {"$ref": "dmos_staff_header.json" }
    },
    "measures": {
         "type": "array",
         "items": {"$ref": "dmos_measure.json" },
           "minItems": 1
    }
  },
   "required": ["id", "region", "headers", "measures"],
  "additionalProperties": false
}
```

#### Staff descriptor

> Form type `ExtGPorteeReco`

There might be a hierarchical grouping of staves in a system.  (piano, strings / winds / organ / etc.) At some
point, a staff belongs to a "part", i.e., the sub-score assigned to a single performer. There might be one (usually), 2 or even 3 staves (organ), and the voices played by the performed can (in the most complex case) be distributed over all the staves of its part. **Thus**, I added the ``id_part`` to the staff descriptor to indicate
the part a staff belongs to. As an inital approx., we can assume that staff = part.

The first bar is a segment that locates the left-most  vertical bar of the system.

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
       "first_bar": {"$ref": "dmos_segment.json" }
   },
   "required": [ "id_part", "no_staff"],
  "additionalProperties": false
}
```

[Example of a system with three staves](http://collabscore.org/dmos/data/ex1/page1_s1.json)

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

[Example of a measure over three staves  (first staff, first system, first page)](http://collabscore.org/dmos/data/ex1/page1_s1_m1.json)

## Voice

A voice (in  a measure) is a sequence of voice elements, which each belongs to one of the staves of the voice's part.

The ``id_part`` property determines the part the voice belongs to, and thus indirectly the list of
staves on which a voice can be spread. 

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

A voice element is either a clef, a not or a rest. It is represented as a graphic symbol and 
corresponds to a duration.

The ``duration`` property gathers all the symbolic constituents that determine the duration  
value:

  - a symbol (whole note, 8th note, quarter rest, etc.)
  - the number of points (each point adds a 1.5 factor to the duration value)

The latter two are optional. Given the current meter and these elements, 
the conversion system can infer the duration.

> Important : the region covered by the element as a complex symbol is given 
> with the duratioin symbol.


> Important: there can probably be other stuff than notes, rests of clefs. To be investigated



```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_element_voice.json",
  "title": "Schema of voice elements",
  "description": "A voice element is a symbol that can appear as part of a voice in a measure. Either a note, a rest or a clef",
  "type": "object",
  "properties": {
    "duration": { "$ref": "dmos_duration.json"},
    "no_group": {"description": "Beaming. To be clarified", "type": "integer"},
    "direction": {"description": "Up or down", "type": "string"},
     "slur": {"description": "A string that starts either with 'i' (inital) or 't' (terminal), followed by the slur id (i.e., i1, i2, t2, t1)", "type": "string"},
    "att_note": { "$ref": "dmos_att_note.json"},
    "att_rest": { "$ref": "dmos_att_rest.json"},
    "att_clef": { "$ref": "dmos_clef.json"},
    "tuplet_info": { "$ref": "dmos_tuplet_info.json"},
    "num": {"description": "Used for tuplet: gives the actual number of events wrt the expected one (specified by numbase)", "type": "integer"},
    "numbase": {"description": "Used for tuplet: gives the expected number of events wrt the actual one (specified by num)", "type": "integer"},
    "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }}
  },
   "required": ["duration"],
  "additionalProperties": false
}
```

[Example: first page, first system, first measure, first part, voice 1](http://collabscore.org/dmos/data/ex1/page1_s1_m1_p1_v1.json)

> I would like using the following structured type for tuplets

```json
 {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_tuplet_info.json",
  "title": "Description of a tuplet",
  "type": "object",
  "properties": {
    "num": {"description": "Used for tuplet: gives the actual number of events wrt the expected one (specified by numbase)", "type": "integer"},
    "num_base": {"description": "Used for tuplet: gives the expected number of events wrt the actual one (specified by num)", "type": "integer"}
   },
   "required": ["num","num_base"],
  "additionalProperties": false
}
```

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
    "other_objects": {"type": "array", "items": { "$ref": "dmos_symbol.json" }},
    "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }}
  },
   "required": ["nb_heads", "heads"],
  "additionalProperties": false
}
```

> Slurs are distinguished from ties by the rule: a tie connects note of similar height.

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
     "visible": {"description": "An invisible rest represents a (temporal) skip in a voice", 
                    "type": "boolean"},
    "heads": {"type": "array", "items": { "$ref": "dmos_note_head.json" }, "minItems": 1},
     "errors": {"type": "array", "items": { "$ref": "dmos_error.json" }}
  },
   "required": ["nb_heads", "heads"],
  "additionalProperties": false
}
```

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
```

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
     "tied": {"description": "Liaison à la note précédente", "type": "boolean"},
     "errors": {"description": "Liste des erreurs", 
                "type": "array",
                "items": { "$ref": "dmos_error.json" }
     }
   },
   "required": ["head_symbol", "no_staff", "height"],
  "additionalProperties": false
}
```

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

### Managing errors

DMOS reports errors, resulting from situation where an equivocal situation is met.
Errors are normalized: a code gives  the type of the error, and a list of key-value pairs provide additional informations about the error.

Here is the formal type:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "dmos_error.json",
  "title": "Schema of DMOS errors",
  "description": "Encoding of an error reported by DMOS: a code, and a list of key-values",
  "type": "object",
  "properties": {
     "code": {"decription": "Normalized code specifying the error type", "type": "string"},
     "values": {"type": "array", 
                "items": { "type": "object", 
                 "properties": {
                       "key": {"type": "string"},
                      "value": {"type": "any"}
                  },
                  "required": ["key","value"],
                  "additionalProperties": false
                }
      }
  },
  "required": ["code"],
  "additionalProperties": false
}
```

And here is an example, with the typical situation of a measure where the sum of events durations differs from the expected value

```json
{
  "code": "supDurErr",
  "values": [{"key": "expected", "value": 4},
             {"key": "found", "value": 5}
            ]
}
```

Individual errors are reported in the ``errors`` array of elements. There might be several errors for a same element.

