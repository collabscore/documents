# Source services

See the introduction on CollabScore services in https://github.com/collabscore/documents/blob/main/devdoc/services.md


## Reading sources information

The services in this do not require authentification.

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

 - ``source_file``: if a source is associated to a file, then this field
   gives the path to the file on the Neuma server.
 - ``manifest``: the
    manifest is a JSON documents that describes the physical organization of the source
    in pages / systems / measures.

```json
{
    "ref": "iiif",
    "description": "Lien Gallica",
    "source_type": "JPEG",
    "mime_type": "image/jpeg",
    "url": "https://gallica.bnf.fr/ark:/12148/bpt6k11620473",
    "source_file": "/media/sources/all-collabscore-saintsaens-ref-C006_0/dmos.json",
    "manifest": "/media/sources/all-collabscore-saintsaens-ref-C006_0/manifest.json"
}
```
You can get  files directly by appending the Neuma URL and the file path. In special
circumstances (Javascript calls with same origin policy), it is necessary to
go through the following services.

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

## Update services

In order to use these services, you must supply a user authentification ``login``
and ``password``. With ``curl``, authentication is provided with the ``-u``
option. 

### Adding a source

To add a source, send a ``PUT`` request to the pscore. The content of the request is a JSON that describes the source, excluding files. For instance:

```json
{"ref":"dmos",
 "description":"DMOS file",
 "source_type":"DMOS",
 "url":""
 }
```

This creates a source with identified by the ``ref``field (``dmos`` in the above example).
The 'source type' must belong to : JPEG, PDF, DMOS, MEI, MusicXML, MP3

Assuming the above JSON object is stored in a ``source_rest.json`` file, the HTTP request is as follows (do not forget the 'Content-type' parameter):

```
curl -u login:password -X PUT "http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/"  -H 'Content-Type: application/json'   -d @source_rest.json
```

Calling ``PUT``twice with the same source reference results in an error.

### Modifying a source

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
curl -u login:password -X POST "http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/dmos/"  -H 'Content-Type: application/json'   -d @source_rest.json
```
### Uploading a source file

A file can be attached to a source (useful if the file is not accessible via a URL). A multipart/form-data HTTP request has to be sent with the file to the ``/_sources/<source_ref>/_file/`` service. With Curl, this is done as follows (assuming the source_ref is 'dmos'):

```
 curl -X POST "http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:C006_0/_sources/dmos/_file/"  -F 'dmos.json=@file.json'
```

If the source does not exist, a generic one is created with a description that features the date of creation.
