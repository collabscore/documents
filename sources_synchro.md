# Synchronization of sources

This documents explains the data organization and services that allows to synchronizes
the *sources* of an *opus*.

## The data model: opus and sources

An Opus in Neuma is a music work associated to digital representations of this work in various formats,
called *sources*. Some sources represent the music score, either in MusicXML or MEI (there should
always be one such source). Others represent images of a score edition, performances, or event texts 
related to the source.

<img width="714" height="412" alt="partitionpivot" src="https://github.com/user-attachments/assets/ea13a2fc-831c-428d-8fae-0188d3d2848d" />

An opus is identified by an absolute path in the tree Neuma of collections (called *corpus*). 
In the following, we illustrate
the synchronization of sources on a music melody by Saint-Saëns, "Aimons-nous". Its id is 
``all:collabscore:saintsaens-audio:C055_0`` (meaning that it is stored in the ``saintsaens-audio`` 
corpus, itself stored in the ``collabscore`` corpus. The local id of the piece in ``saintsaens-audio``
is ``C055_0``.

In the web interface of Neuma, the piece and its sources can be inspected at https://home/opus/all:collabscore:saintsaens-audio:C055_0/.
From now on, we will focus on REST services.

## Web Services to get an Opus and its sources

All services are rooted at https://neuma.huma-num.fr/rest/collections. Some useful GET services: 
 
  - Representation of an Opus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0
  - List of sources of an Opus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/
  - The MusicXML source: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/musicxml/
  - The MusicXML file: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/musicxml/_file
  - The image source: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/iiif
 - The audio source: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/audio

## Linking sources with annotations

Sources can be interlinked with annotations. The principle is to use the MusicXML source as a  *pivot score*. An annotation associates an *element* of the pivot score (a measure, a staff, a note) to a *fragment* of a source.
The former is the *target* of the annotation, the latter the *body*.
We comply as much as possible to the annotation model of the W3C (https://www.w3.org/TR/annotation-model/)

### Annotation of images

In that case we associate an element of the pivot to the corresponding region on the image. Elements can be : systems, measures, measure/staves and notes/rests/chords.

In order to obtain the regions for all the measures, one can call the following service: 

https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_annotations/image-region/measure-region/

 
Here is an example of an annotation that tells the *region* in the image source that corresponds to
the first measure (``m1``).

```json
"m1": [
    {
      "id": 3260193,
      "body": {
        "source": "https://gallica.bnf.fr/iiif/ark:/12148/bpt6k11620688/f2",
        "selector": {
          "type": "FragmentSelector",
          "value": "((P1221,1589)(P2151,1589)(P1221,2266)(P2161,2266))",
          "conformsTo": "http://www.w3.org/TR/SVG/"
        }
      },
      "target": {
        "source": "/media/sources/all-collabscore-saintsaens-audio-C055_0/score.mei",
        "selector": {
          "type": "FragmentSelector",
          "value": "m1",
          "conformsTo": "http://tools.ietf.org/rfc/rfc3023"
        }
      },
      "annotation_model": "image-region",
      "annotation_concept": "measure-region"
    }
  ],
```

### Annotations of audio

These annotations associate an element of the pivot to a time frame in the audio file. Exemple for *Aimons-nous*:

https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_annotations/time-frame/measure-tframe/

Example for the same measure.

```json
"m1": [
    {
      "id": 3754548,
      "body": {
        "source": "https://openapi.bnf.fr/iiif/audio/v3/ark:/12148/bpt6k88448791/3.audio",
        "selector": {
          "type": "FragmentSelector",
          "value": "t=0,4.852608",
          "conformsTo": "https://www.w3.org/TR/media-frags/#naming-time"
        }
      },
      "target": {
        "source": "/media/corpora/all/collabscore/saintsaens-audio/C055_0/score.xml",
        "selector": {
          "type": "FragmentSelector",
          "value": "m1",
          "conformsTo": "http://tools.ietf.org/rfc/rfc3023"
        }
      },
      "annotation_model": "time-frame",
      "annotation_concept": "measure-tframe"
    }
```
### Synchronization

The same element from the pivot score (say, measure m1, m2, etc.) appears both in the ``image-region`` annotation (which refers
to a region) and the ``time-frame`` annotation (which refers to a time frame in the audio file).  To summarize, this lets us associate a region on the image and the time frame of the corresponding performance. It is not 
even necessary to access to the MusicXML or MEI file which only serves as a common reference.

# Howto: creating a synchro on Neuma

## Opus and sources
Assume an opus with an image source and an audio source. We take the 'Danse macabre' (DM) as an illustrating example. It must be registered as a Neuma opus, such as:
https://neuma.huma-num.fr/home/opus/all:collabscore:saintsaens-audio:R171_3/

Both sources need to be referred to by a IIIF manifest. There must be an image source (with ref iiif) and an audio source (with ref audio), and the URL field refers to the IIIF manifest.

 - https://gallica.bnf.fr/iiif/ark:/12148/bpt6k1170198d/manifest.json
 - https://openapi.bnf.fr/iiif/presentation/v3/ark:/12148/bpt6k8823171f/manifest.json

## Annotations

Next, we must create annotations for both the image and audio sources, referring 
to the common opus pivot score.

 - for images, annotations are created with the ORM process
 - for audio, several solutions
     -   we can use Audacity, place markers at the beginning of each measure and export the markets as a text file. This file must be then imported as the file of the audio source. it is processed at insertion time, converted in JSON, and temporal annotations are  created
     -   we can probably align the audio and the score automatically, to be investigated

Uploading the TXT markers:

```
 curl  -u login:password -X POST "http://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-ref:R171_3/_sources/iiif/_file/"  -F 'labels.txt=@file.json'
```

Annotations can be retrieved as services:
  - https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:R171_3/_annotations/image-region/measure-region/
  - https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:R171_3/_annotations/time-frame/measure-tframe/

## The combined manifest

A combined IIIF manifest must then be produced. Digirati has created a helper website (https://bnf-prototype.netlify.app/) which supports the combined Manifest generation process. You can provide the different sources and then use the ‘Generate Manifest’ link to create the combined manifest, which you can then download and save. You can then store/host that Manifest somewhere appropriate, before passing the manifest URLs to the viewer(s).

In Neuma, we crate a special source, 'sync', and the combined manifest is inserted there
as the source file. It gets a URL, for instance
https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:R171_3/_sources/sync/_file/

Finaly we can pass this URL to the Theseus viewer: https://theseusviewer.org/?iiif-content=https://neuma.huma-num.fr/rest/collections/all%3Acollabscore%3Asaintsaens-audio%3AR171_3/_sources/sync/_file/

There is a link to the viewer in the list of sources of the Opus in Neuma. The code
and the viewer and some explanations can be found at https://github.com/digirati-co-uk/bnf-prototype




