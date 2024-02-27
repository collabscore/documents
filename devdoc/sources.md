# Source services

See the introduction on CollabScore services in https://github.com/collabscore/documents/blob/main/devdoc/services.md

Accessing sources requires a pscore identifier (see the above reference). In
order to get the list of sources, one  calls the ``_sources`` services
on this identifier.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/
```

One can further refine the search by adding the source reference. The following 
call gets the ```iiif```  source.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/iiif/
```

In the following JSON representation, one notes two important fields

 - the ``file_path``: if a source is associated to a file, then this field
   gives the path to the file on the Neuma server.
 - ``has _manifest``tells whether the source has a manifest (surprise!). The
    manifest is a JSON documents that describes the physical organization of the source
    in pages / systems / measures.

```json
{
    "ref": "iiif",
    "description": "Lien Gallica",
    "source_type": "JPEG",
    "mime_type": "image/jpeg",
    "url": "https://gallica.bnf.fr/ark:/12148/bpt6k11620473",
    "file_path": "/media/sources/all-collabscore-saintsaens-ref-C006_0/dmos.json",
    "has_manifest": true
}
```

The source file can be retrieved by adding the ``_file`` keyword at the
end of the source URL.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/iiif/_file/
```

The source manifest can be retrieved by adding the ``_manifest`` keyword at the
end of the source URL.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/iiif/_manifest/
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




