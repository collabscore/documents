# CollabScore services

CollabScore proposes a RESTful interface to communicate with the digital library. 
All documents exchanged are JSON-encoded.  All services are rooted at http://neuma.huma-num.fr/rest

The main objects to interact with are

 - *Pivot scores*, or *pscore* in short: a MEI-encoded music score, linked to *sources* via *annotations*
 - *Collections*: like directories in file systems ; a collection contains pscore and/or sub-collections.

Collections and pscores are uniquely identified with an *id* which takes the form ``Ci:Cj:...:R``.
An id is built from the sequence of collection ids from the root (named ``all``) to the resource ``R``, 
separated by semicolons. For instance 

 - the id of the CollabScore collection  is ``all:collabscore``
 - the id of the basic sample file ``dmos_ex1`` pscore in CollabScore is ``all:collabscore:dmos_ex1``
    is <tt>c1:c4:o2</tt>
All CollabScore collections are rooted at 

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
