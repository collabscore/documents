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
The serialization is based on JSON. An operation is always send/received
to/from the ``iiif`` source of a Opus. In general, such a source
is referred to by combining the Opus ref, the keyword ``_sources``
and the source code (``iiif`` in our case). Here is an example:

```
all:collabscore:saintsaens-ref:C006_0/_sources/iiif/
```

The Opus ref can be replaced by its database id, e.g., 

```
22468/_sources/iiif/. See the document on sources.
```
We use this URL for illustrating the services below.

### Retrieving editions

The list of editions for a source can be obtained with a GET

http://neuma.huma-num.fr/rest/collections/22468/_sources/iiif/_editions

The services returns an array of editions:

```json
[
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
},
  {
	"name": "describe_part",
	"params": {
		"part": "Part1",
		"values": {
                        "intrument": "Piano",
			"name": "Piano",
			"abbreviation": "P."
		}
	}
   }
]
```

### Adding an edition

Adding an edition is a POST sent to the source URL. The message body
is the JSON representation of the edition.
