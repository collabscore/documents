# CollabScore services

CollabScore proposes a RESTful interface to communicate with the digital library. 
All documents exchanged are JSON-encoded.  
  - All services are rooted at https://neuma.huma-num.fr/rest
  - A Swagger interface with all services is available at http://neuma.huma-num.fr/schema/swagger-ui/
  - A Redoc interface with all services is available at http://neuma.huma-num.fr/schema/redoc/

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
 - Pscore ``C006_0`` can be consulted (and edited for authorized users) at https://neuma.huma-num.fr/home/opus/all:collabscore:saintsaens-ref:C006_0/ in the sub-collection ``tests``.

For the REST interface, we replace ``home/corpus`` with ``rest/collections``. 

 - Collection CollabScore can be consulted at https://neuma.huma-num.fr/rest/collections/all:collabscore/
 - Its set of pscores is at https://neuma.huma-num.fr/rest/collections/all:collabscore/_opera/
 - A specific pscore such as ``C006_0``, in the sub-collection 'sainsaens-ref', is accessible  at https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/

In this document, we document the set of web services useful to CollabScore. 

## Getting collections and pscores

### Collections

Given a collection, you can retrieve the list of sub-collections with the ``_corpora``
service. The sub-collections of CollabScore are obtained by calling the service:

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore/_corpora/
```
You should find a sub-collection with  ref ``saint-saens-ref``.  
The list of pscores in a collection is obtained with the ``_opera`` service.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref/_opera/
```

### Pscores: meta-data and score files

The description of a pscore is obtained from the pscore id:

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/
```

A pscore is associated  to a set of *sources*, or digital documents encoding information about the pscore.
One obtains a json with all the files and their URLs.

```json
{
"ref": "C006_0",
"title": "[Dans les coins bleus] ",
"composer": "Saint-Saëns, Camille ",
"features": [],
"sources": [
 {
  "ref": "iiif",
  "description": "Lien Gallica",
  "source_type": "JPEG",
  "mime_type": "image/jpeg",
  "url": "https://gallica.bnf.fr/ark:/12148/bpt6k11620473",
  "images": []
  },
  {
  "ref": "mei",
  "description": "MEI generated on ...",
  "source_type": "MEI",
  "mime_type": "application/xml",
  "url": "https://neuma.huma-num.fr/media/sources/all-collabscore-saintsaens-ref-C006_0/C006_0.mei"
  }
  {
  "ref": "midi",
  "description": "MIDI file generated on 2023-12-21",
  "source_type": "MIDI",
  "mime_type": "audio/midi",
  "url": "https://neuma.huma-num.fr/media/sources/all-collabscore-saintsaens-ref-C006_0/score.midi"
  }
]
}
```

In the above example, we obtain 3 sources:
  - ``iiif`` is a source supplied by an IIIF server, typically Gallica (BnF). It may come
     with a list of *images* URLs (all the pages of the source)
  - ``mei`` is a MEI encoding of the source content
  - ``midi`` is a midi generated from the MEI

Etc. There might be MusicXML sources, video or audio source, etc. 

### Services on sources

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




