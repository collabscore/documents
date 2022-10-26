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

One can interact with a pscore either with a Web interface or with the Restful interface. Examples for the Web interface:

 - Collection CollabScore can be consulted (and edited for authorized users) at http://neuma.huma-num.fr/home/corpus/all:collabscore/
 - Pscore ``dmos_ex1`` can be consulted (and edited for authorized users) at http://neuma.huma-num.fr/home/opus/all:collabscore:dmos_ex1/

Example for the REST interface 

 - Collection CollabScore can be consulted at http://neuma.huma-num.fr/rest/collections/all:collabscore/, 
 - Its set of pscores is at http://neuma.huma-num.fr/rest/collections/all:collabscore/_opera/
 - A specific pscore such as ``dmos_ex1`` is accessible at: http://neuma.huma-num.fr/rest/collections/all:collabscore:dmos_ex1/

In this document, we document the set of web services useful to CollabScore. A Swagger interface with all services is
available at http://neuma.huma-num.fr/rest/swagger/.

## Getting collections and pscores

### Collections

Given a collection, you can retrieve the list of sub-collections with the ``_corpora``
service. The sub-collections of CollabScore are obtained by calling the service:

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore/_corpora/
```

The list of pscores in a collection is obtained with the ``_opera`` service.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore/_opera/
```

### Pscores: meta-data and score files

The meta-description of a pscore is obtained from the pscore id:

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:dmos_ex1/
```

A pscore is associated  to a MEI file which is the reference encoding of the pscore content. There might also be a MusicXML file. The list of score files associated to a pscore is obtained with the ``_files`` service.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:dmos_ex1/_files/
```
One obtains a json with all the files and their URLs.
 
```json
{
  "ref":"dmos_ex1",
 "title":"Test collabscore",
  "files": ["score.xml":{"url":"http://localhost:8000/media/corpora/all/collabscore/dmos_ex1/score.xml"},
             "mei.xml":{"url":"http://localhost:8000/media/corpora/all/collabscore/dmos_ex1/mei.xml"}
           ]
}
```

### Pscore: sources

A pscore is linked to *sources*, each source being a digital representation of a  pscore in a multimedia format: image, audio,
video, etc.

The list of sources of a pscore can be obtained with the ``_sources`` services.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:dmos_ex1/_sources/
```

The services returns a list of sources descriptions. For instance, the following document
details two sources: an image (Gallica address) and a MEI that can be used as a reference to compare
with the OMR output.

```json
{"ref":"saintsaens71.1",
  "sources":[
       {"ref":"L-1718",
          "source_type":"JPEG",
          "mime_type":"image/jpeg",
          "url":"https://gallica.bnf.fr/ark:/12148/bpt6k1174892k"},
        {"ref":"iremus",
         "source_type":"MEI",
         "mime_type":"application/xml",
         "url":"to_mei_doc.xml"}
       ]
 }
```

## Adding a source

To add a source, send a PUT request to the pscore. The content of the request is a JSON that describes the source. For instance:

```json
{"ref":"dmos",
 "description":"DMOS file",
 "source_type":"DMOS",
 "mime_type":"application/json",
 "url":""
 }
```

The 'source type' must belong to : JPEG, DMOS, MEI, MXML, MP3

Assuming the above JSON object is stored in a ``source_rest.json`` filoe, the HTTP request is as follows:

```
curl -X PUT "http://localhost:8000/rest/collections/all:collabscore:tests:vivelevent/_sources/"  -H 'Content-Type: application/json'   -d @source_rest.json
```


## Adding annotations

To come soon



