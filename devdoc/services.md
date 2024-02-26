# CollabScore services

CollabScore proposes a RESTful interface to communicate with the digital library. 
All documents exchanged are JSON-encoded.  All services are rooted at https://neuma.huma-num.fr/rest

The main objects to interact with are

 - *Pivot scores*, or *pscore* in short: a piece of music, containing *sources*
 - *Sources* : digital document that provide a representation of the pscore -- MEI, MusicXML, Images, MIDI, etc.
 - *Collections*: like directories in file systems ; a collection contains pscore and/or sub-collections.
 - *Annotations*: they related fragments of sources that correspond to one another (for instance, measures)

Annotations services are covered in https://github.com/collabscore/documents/blob/main/devdoc/annotations.md. The following focuses on collections, pscores and sources.

## Identification

Collections and pscores are uniquely identified with an *id* which takes the form ``Ci:Cj:...:R``.
An (full) id is built from the sequence of collection ids from the root (named ``all``) to the resource ``R``, 
separated by semicolons. ``R``is called the *local id*. For instance 

 - the full id of the CollabScore collection  is ``all:collabscore``, its local id is collabcore
 - the full id of the Saint-Saëns reference collection  is ``all:collabscore:saintsaens-ref``
 - the *local id of the pscore "Dans les coins bleus" is ``C006_0``, and its
   full id   is ``all:collabscore:saintsaens-ref:C006_0``

One can interact with a pscore either with a Web interface or with the Restful interface. Examples for the Web interface:

 - Collection CollabScore can be consulted (and edited for authorized users) at https://neuma.huma-num.fr/home/corpus/all:collabscore:saintsaens-ref/
 - Pscore ``dmos_ex1`` can be consulted (and edited for authorized users) at https://neuma.huma-num.fr/home/opus/all:collabscore::saintsaens-ref:C006_0/ in the sub-collection ``tests``.

For the REST interface, we replace ``home/corpus`` with ``rest/collections``. The id of the opus can be either given with the ':' separator, or with '/', as in a file system.

 - Collection CollabScore can be consulted at http://neuma.huma-num.fr/rest/collections/all:collabscore/, or http://neuma.huma-num.fr/rest/collections/all/collabscore/
 - Its set of pscores is at http://neuma.huma-num.fr/rest/collections/all:collabscore/_opera/
 - A specific pscore such as ``dmos_ex1``, in the sub-collection 'tests', is accessible either at: http://neuma.huma-num.fr/rest/collections/all:collabscore:tests:dmos_ex1/ or http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/dmos_ex1/ 

In this document, we document the set of web services useful to CollabScore. A Swagger interface with all services is
available at http://neuma.huma-num.fr/rest/swagger/.

## Getting collections and pscores

### Collections

Given a collection, you can retrieve the list of sub-collections with the ``_corpora``
service. The sub-collections of CollabScore are obtained by calling the service:

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all/collabscore/_corpora/
```

The list of pscores in a collection is obtained with the ``_opera`` service.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all/collabscore/_opera/
```

### Pscores: meta-data and score files

The meta-description of a pscore is obtained from the pscore id:

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/
```

A pscore is associated  to a MEI file which is the reference encoding of the pscore content. There might also be a MusicXML file.  One obtains a json with all the files and their URLs.
 
```json
{
"ref": "dmos_ex1",
"title": "Test collabscore",
"composer": null,
"lyricist": null,
"corpus": "all:collabscore:tests",
"meta_fields": [],
"sources": [],
"files": {
 "score.xml": {
    "url": "http://localhost:8000/media/corpora/all/collabscore/tests/dmos_ex1/score.xml"
  },
  "mei.xml": {
  "url": "http://localhost:8000/media/corpora/all/collabscore/tests/dmos_ex1/mei.xml"
  }
 }
}
```

### Pscore: sources

A pscore is linked to *sources*, each source being a digital representation of a  pscore in a multimedia format: image, audio,
video, etc.

The list of sources of a pscore can be obtained with the ``_sources`` services.

```
curl -X GET "http://neuma.huma-num.fr/rest/collections/all/collabscore/tests/vivelevent/_sources/"
```

The services returns a list of sources descriptions. For instance, the following document
details two sources: an image (Gallica address) and a MEI that can be used as a reference to compare
with the OMR output.

```json
{
"ref": "vivelevent",
"sources": [
{
"ref": "dmos",
"description": "DMOS file",
"source_type": "DMOS",
"mime_type": "application/json",
"url": "http://neuma.huma-num.fr/media/sources/all-collabscore-tests-vivelevent/dmos.json"
}
]
}
```

## Adding a source

To add a source, send a PUT request to the pscore. The content of the request is a JSON that describes the source. For instance:

```json
{"ref":"dmos",
 "description":"DMOS file",
 "source_type":"DMOS",
 "url":""
 }
```

The 'source type' must belong to : JPEG, PDF, DMOS, MEI, MusicXML, MP3

Assuming the above JSON object is stored in a ``source_rest.json`` file, the HTTP request is as follows (do not forget the 'Content-type' parameter):

http://neuma.huma-num.fr/rest/collections/all/collabscore/saintsaens-ref/C452_0/_sources/

```
curl -X PUT "http://neuma.huma-num.fr/rest/collections/all/collabscore/saintsaens-ref/C452_0/_sources/"  -H 'Content-Type: application/json'   -d @source_rest.json
```

## Modifying a source

Same call, but adding the source ref to the URL, and using POST. There is no need to use the ``ref`` field in tje JSON file. For instance:

```json
{
 "description":"DMOS file",
 "source_type":"DMOS",
 "url":""
 }
```
Example of calling the source update service:

```
curl -X POST "http://neuma.huma-num.fr/rest/collections/all/collabscore/saintsaens-ref/C452_0/_sources/dmos/"  -H 'Content-Type: application/json'   -d @source_rest.json
```


## Uploading a source file

A file can be attached to a source (useful if the file is not accessible via a URL). A multipart/form-data HTTP request has to be sent with the file to the ``/_sources/<source_ref>/_file/`` service. With Curl, this is done as follows (assuming the source_ref is 'dmos'):

```
 curl -X POST "http://neuma.huma-num.fr/rest/collections/all/collabscore/saintsaens-ref/C452_0/_sources/dmos/_file/"  -F 'dmos.json=@file.json'
```

If the source does not exist, a generic one is created with a description that features the date of creation.




