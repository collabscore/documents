# Managing editions in CollabScore

Music scores in CollabScore are obtained via Optical Music Recognition (OMR)
applied to IIIF *sources* (see https://github.com/collabscore/documents/blob/main/devdoc/sources.md). 
The OMR proceeds in two phases

 - a JSON file reporting the music symbols found in the score image is produced by the OMR software DMOS
 - a transcription of the JSON content in a standard music score format

The result of the two-phases process  is an XML file (MusicXML or MEI). Since
OMR is inherently error-prone, this file needs to be completed and/or corrected.

  - *completion* may be adding metadata, or adjusting the regions recognized by ORM
  - *correction* is any action that fixes a faulty OMR output

Both completion and corrections are referred to as *editions* in CollabScore.
generally speaking, and edition is an operation applied during the transcription
of the JSON file to the XML file. This operation has a *name* and a list
of *parameters*.

##  Example of an operation

A music score consists of *parts*, i.e., a set of instructions given to 
a performer playing an instrument. In a score one may find a piano part, a
violin part, etc.

In general OMR cannot extract the description of a part, and it has therefore
to be supplied via and external source (a user generally). The description
of a part consists of

 - its instrument (taken from a taxonomy, in order to identify transposing instruments)
 - its name (free text), to be displayed generally at the beginning of the first part's system(s) in the score 
 - its abbreviation, to be used in subsequent systems.

Specifying the description of a part is done with an operation named ``describe_part`` 
that takes as parameter the target part and the above attributes. Its JSON description is as follows:

```json
{
	"name": "describe_part",
	"params": {
		"part": "Part2",
		"values": {
      "intrument": "Chant",
			"name": "Ténor",
			"abbreviation": "T."
		}
	}
}
```

So the operation has two parameters: ``part``, the id of the part, and
``values``, which is itself an object with three attributes. 

The names and types of the parameters changes from one operation to the other,
but an operation has *always* a ``name``, from which the expected parameter 
values can be decoded.


## Services on operations

The CollabScore server exchanges operations via REST services. 
The serialization is based on JSON. 

### Retrieving operations

Statistics on annotations are obtained with the ``_annotations`` keyword that serves as root for all annotation services. The result of

http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/_stats/

should look like:

```json
{
  "count": 386,
  "details": [
    {
      "model": "omr-error",
      "count": 80
    },
    {
      "model": "image-region",
      "count": 306
    }
  ]
}
```

Adding the code of an annotation model gives the statistics per annotation concept. Exemple for the model 'image-region':

http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/_stats/

Result:

```json
{
  "model": "image-region",
  "count": 386,
  "details": [
    {
      "code": "mstaff-region",
      "count": 153
    },
    {
      "code": "measure-region",
      "count": 153
    }
  ]
}
```

Adding the ``_all`` keyword retrieves the list of annotations for the model. 

http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/_all/

In the results,
annotations are grouped by the id ot the target element. In the example below, P0m11n1 and P0m11n2 are two such elements. The struture
allows to easily find the annotations pertaining to a specific element.

```json
{
  "P0m11n1": [
   {
    "id": 11319, "type": "Annotation", "creator": {"id": 5,"type": "Person", "name": "rigaux"},
    "motivation": "linking",
     "annotation_model": "image-region",
     "annotation_concept": "note-region",
      "body": {}, "target": {}
   },
   {}
 ]
 "P0m11n2": []
}
```

The list of annotations can be restricted to a single concept: 

 - http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/measure-region/ for regions covering all the staves of a measure
 - http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/mstaff-region/ for regions covering a single staff of a measure

### Deleting annotations

Deletion is obtained by sending a ``DELETE`` HTTP request, along with the user credentials.

```
curl -u login:password -X DELETE  http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/image-region/_all/ 
```

No ``rollback`` or confirmation mechanism. Be careful...

### Create, update and get a specific annotation

All these services are rooted at http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/.

#### Getting an annotation

Simply give the notification id, for instance: http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/1234/

#### Deleting an annotation

Send to the above URL a ``DELETE``HTTP request, along with the user credentials. For instance: 

```
curl -u collabscore:pwd -X DELETE http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/1234/
```

#### Putting an annotation

Send a PUT request to the ``_annotations`` service, along with the user credentials. The body of the request is a JSON
document that complies to the model outlined above. 
With ``curl``, the syntax is

```
curl -u login:password -X PUT  http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/ \
     -H "Content-Type: application/json" \
     -d @file.json 
```

The JSON file represents an annotation, without the id (generated by Neuma), the creator (idem). Example for a time frame annotation:

```json  
{
	"type": "Annotation",
	"motivation": "linking",
	"annotation_concept": "note-tframe",
	"body": {
		"type": "SpecificResource",
		"resource": {
			"source": "http://neuma.huma-num.fr/media/corpora/all/collabscore/saintsaens-ref/C006_0/vvl.mp3",
			"selector": {
				"type": "FragmentSelector",
				"conformsTo": "https://www.w3.org/TR/media-frags/#naming-time",
				"value": "t=23,26"
			}
		}
	},
	"target": {
		"resource": {
			"source": "http://neuma.huma-num.fr/media/corpora/all/collabscore/saintsaens-ref/C006_0/mei.xml",
			"selector": {
				"type": "FragmentSelector",
				"conformsTo": "http://tools.ietf.org/rfc/rfc3023",
				"value": "P0m11n1"
			}
		},
		"type": "SpecificResource"
	}
}
```
The service returns (if everything is OK) a JSON message featuring the new annotation id:

```json
{"message":"New annotation created on all:collabscore:saintsaens-ref:C006_0","annotation_id":11723}
```

The new annotation can be retrieved with:
http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_annotations/11723/
