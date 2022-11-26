# Managing annotations in CollabScore

CollabScore manages interlinked *multimodal* representations of music items, called *multimodal scores* (*mscore* for short). A mscore consists of:

 - A *pivot score* is an encoding of a music piece content based on music notation concepts. In practice, a pscore is a MEI document where *all* elements (measures, notes, rests, cleefs, etc.) are uniquely identified  and thus can be referred to by URIs.
 - One or several *sources*, i.e. multimedia documents that instantiate a representation of the music  item in a specific format: audio, video, image, XML encoding, etc.
 - *Annotations* that associate  elements of the pivot score to fragments of each source. 
 
![Multimodal score](/figures/partitionMM.png)

The following focuses on annotations. 

##  Annotations

We comply as much as possible to the annotation model of the W3C (https://www.w3.org/TR/annotation-model/). In particular, web services of CollabScore exchange annotations serialized in JSON-LD.

### The Annotation object

An annotation is described by the following properties:

  - a unique id
  - the *creator* of the annotation (see below)
  - dates of creation and last update
  - the *motivation*, is a character string which, for the time being is either *linking*, *commenting* or *questioning* ; it appears essentially for compatibility with the W3C, but its use for CollabScore is not yet established 
  - the *target* and the *body* (see below)
  - the *annotation model* and the *annotation concept* in this model (see below)
 
The main properties are the *target* and the *body*. In CollabScore, 
an element of the pscore is annotated and constitutes the *target* of the annotation, whereas 
what is said about this target is the annotation *body*. If, for instance, we want 
to represent as an annotation the fact that a measure in the pscore corresponds to a region in
an image source, we create an annotation such that:

  - the *target* is the URL that leads to the annotated measure in the MEI document of the pscore.
  - the *body* is the URL that refers to the part of the source image covered by the region.

The target is always a (web) *resource*. The body may be a web resource as well, but also a textual fragment or any
other piece of digital information. The other
properties of an annotation help to understand the context of its creation and usage. 
These concepts are now detailed.

### Annotation models and concepts

In CollabScore, an *annotation model* represents the purpose of annotating a music item. It consists of a 
set of *concepts* denoting a specific type of annotation related to the model. Here is the list of
models used by CollabScore:

#### The image-region model

This model is used to link a pscore (the MEI document) with regions of an image. It contains the following concepts:

  - ``measure-region``: the annotations refers to a measure
  - ``note-region``: the annotations refers to a note or rest
 
#### The time-frame model

This model is used to link a pscore (the MEI document) with time frame in an audio or video. It contains the following concepts:

  - ``measure-tframe``: the annotations refers to a measure
  - ``note-tframe``: the annotations refers to a note or rest

#### The xml-fragment model

This model is used to link a pscore (the MEI document) with with another XML encoding. *To be elaborated.*

#### The ORM model

This model is used to link a pscore (the MEI document) with errors and questions issued from the OMR process.
It is note covered in the present document.

### Resources and fragments

A resource is an object located at a specific URL. In practice, it can be a document, a fragment of a document or any service yielding such a representation. In CollabScore, we deal with either *full Resource*, or
(more frequently) *resource fragments* (aka *specific resources* in the W3C document). 
A resource fragment is described by two fields:

 - *source*, the resource URL
 - a fragment *selector*

The fragment selector tells how to extract the fragment representation from the source. Its specific
representation depends on the source media: it can be a region (images), a temporal interval (audio and video), an XPath expression. Therefore a fragment selector is described by:

 - a *conforms_to* field that states the fragment selection mechanism  (for instance, https://www.w3.org/TR/media-frags/)
 - a *value* that gives the selector expression

The ``conforms_to`` field is determined by the annotation model. 

 - If  the model is ``image-region``, then the resource is an image URL, and the selector is a region in this image, and the region *representation* conforms to the specification of https://www.w3.org/TR/media-frags/#naming-space. 
 - If the model is ``time-frame``, the resource is an audio or video document, and the selector is a time frame conforms to https://www.w3.org/TR/media-frags/#naming-time
 - If the model is ``xml-fragment``, the selector is conforms to	http://tools.ietf.org/rfc/rfc3023

### Representing targets and bodies

The target of an annotation is always a resource (or resource fragment). The body is either

 - a resource or resource fragment ("Resource body" in the W3C model),
 - a simple text ("Textual body" in the W3C model)

### Creator

The creator of an annotation is a triplet ``(id, type, name)`` where ``type``is either 
``Person`` or ``Software``.


# Annotation services

The CollabScore server exchanges annotations via REST services. The serialization is based on JSON. 
Here is a first example. It represents an annotation of a measure element with id 'lkx123' in the 
(fictive) "http://collabscore.org/target.mei" document that links this element to the time frame (10,20) in the (fictive)
audio document http://collabscore.org/body.mp3.

```json
{
	"id": 1234,
	"creator": {"id": 1,	"type": "Person", "name": "collabscore" },
	"motivation": "linking",
	"annotation_model": "time-frame",
	"annotation_concept": "measure_region",
	"target": {
		"type": "SpecificResource",
		"resource": {
			"source": "http://collabscore.org/target.mei",
			"selector": {
				"type": "FragmentSelector",
				"conformsTo": "http://tools.ietf.org/rfc/rfc3023",
				"value": "id('lkx123')"
			}
		}
	},
	"body": {
		"type": "SpecificResource",
		"resource": {
			"source": "http://collabscore.org/body.mp3",
			"selector": {
				"type": "FragmentSelector",
				"conformsTo": "https://www.w3.org/TR/media-frags/#naming-time",
				"value": "t=10,20"
			}
		}
	}
}
```

Fields ``id``, ``creator``, and ``annotation_model`` are optional and don't need to be supplied 
during an insertion or update request, as they are automatically inferred from the context.

There exists a JSON utility to test / validate / analyze annotations and theirs JSON serialization. Look at the [README.md ](https://github.com/collabscore/utilities/blob/master/annotations/README.md) file for instructions.

Some aspects of the JSON format are further explained below, before listing the services.

## JSON serialization

In the context of CollabScore, the *target* should always be the pivot score, and more specifically 
the MEI document attached to it. The element referred to can be any element in the MEI. However, for source
alignment purposes, element that correspond to some temporal granularity are priviledged. The form of the
``target`` field is therefore always: 

```json
{
    "target": {
		    "type": "SpecificResource",
	    	"resource": {
		     	"source": "http://collabscore.org/target.mei",
		     	"selector": {
			     	"type": "FragmentSelector",
			      	"conformsTo": "http://tools.ietf.org/rfc/rfc3023",
			      	"value": "id('lkx123')"
			     }
     }
}
```

The body field is more versatile. It is always a ``SpecificResource`` with a fragment selector, but the selector itself
depends on the source type.

### Linking with images

The selector is a quadruplet ``xywh`` that gives the  coordinates of the top-left point of the region, followed by its
width and height. The format follows the recommendations of https://www.w3.org/TR/media-frags/#naming-space. 


```json
{
  "body": {"type": "SpecificResource", 
          "resource": {"source": "http://collabscore.org/body.jpg", 
                       "selector": {"type": "FragmentSelector", 
                                     "conformsTo": "https://www.w3.org/TR/media-frags/#naming-space", 
                                     "value": "xywh=32,216,60,60"}
                       }
           }, 
}
```

Note :  if the image server is equipped with IIIF functionalities, the IIIF reference can be inferred from the information above. In the future, CollabScore might provide directly, *in the output of its web services*, a pre-built IIIF address.

### Linking with audio and video

Same comment as above. The format is taken from https://www.w3.org/TR/media-frags/#naming-time. See the first
example of JSON serialization given above.

### Linking with XML encodings

The form of the body is similar to that of the target.

```json
{
  "body": {"type": "SpecificResource", 
          "resource": {"source": "http://collabscore.org/body.mei", 
                       "selector": {"type": "FragmentSelector", 
                                     "conformsTo": "http://tools.ietf.org/rfc/rfc3023", 
                                     "value": "id('my-id-in-body')"
                                     }
                       }
           }, 
}
```
### Serializing / deserializing with the CollabScore utility

The CollabScore utilities feature a Python module to serialize / deserialize annotations. A command-line 
script, ``annot_utils.py``, relies on this module for testing and checking annotations exchanges.

## Annotation services

REST services allow the retrieval, insertion and update of annotations. Examples are based on the following pscore: http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent. 

> In the case of PUT/POST/DELETE requests, the user credentials has to be provided. With ``curl``, this is done with the ``-u login:password`` option. In the following, the fictive ``collabscore:pwd`` user is assumed.

### Retrieving annotations

Statistics on annotations are obtained with the ``_annotations`` keyword that serves as root for all annotation services. The result of

``
curl http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_annotations/_stats/
``

should look like:

```json
{
"total_annotations": 200,
"count_per_model": [
{ "model_code": "omr-error", "count": 100},
{"model_code": "image-region","count": 100}
]
}
```

Adding the code of an annotation model gives the statistics per annotation concept. Exemple for the model 'image-region':
http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_annotations/image-region/_stats/:

```json
{
"annotation_model": "image-region",
"total_annotations": 200,
"count_per_concept": [
{"concept_code": "note-region", "count": 100}
]
}
```

Adding the ``_all`` keyword retrieves the list of annotation for the model. http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_annotations/image-region/_all/. In the results,
annotations are grouped by the id ot the target element. Inn the example below, P0m11n1 and P0m11n2 are two such elements. The struture
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
The list of annotations can be restricted to a single concept: http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_annotations/image-region/note-region/_all/

### Deleting annotations

Deletion is obtained by sending a ``DELETE`` HTTP request, along with the user credentials.

```
curl -u login:password -X DELETE  http://localhost:8000/rest/collections/all/collabscore/tests/vivelevent/_annotations/image-region/_all/ 
```

No ``rollback`` or confirmation mechanism. Be careful...

### Create, update and get a specific annotation

All these services are rooted at http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_annotations/.

#### Getting an annotation

Simply give the notification id, for instance: http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_annotations/1234/

#### Deleting an annotation

Send to the above URL a ``DELETE``HTTP request, along with the user credentials. For instance: 

```
curl -u collabscore:pwd -X DELETE http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_annotations/1234/
```

#### Putting an annotation

Send a PUT request to the ``_annotations`` service, along with the user credentials. The body of the request is a JSON
document that complies to the model outlined above. 
With ``curl``, the syntax is

```
curl -u login:password -X PUT  http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_annotations/ \
     -H "Content-Type: application/json" \
     -d @file.json 
```
The service returns (if everything is OK) a JSON message featuring the new annotation id:

```json
{"message":"New annotation created on all:collabscore:tests:vivelevent","annotation_id":11723}
```
