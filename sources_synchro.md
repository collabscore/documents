# Synchronization of sources

This documents explains the data organization and services that allows to synchronizes
the *sources* of an *opus*.

## Opus and sources

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

## Services

All services are rooted at https://neuma.huma-num.fr/rest/collections. Some useful GET services: 
 
  - Representation of an Opus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0
  - List of sources of an Opus: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/
  - The MusicXML source: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/musicxml/
  - The MusicXML file: https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/musicxml/_file

## Linking sources with annotations

Sources can be interlinked with annotations. The principle is to use the MusicXML source as a  *pivot score*. An annotation associates an *element* of the pivot score (a measure, a staff, a note) to a *fragment* of a source.
The former is the *target* of the annotation, the latter the *body*.
We comply as much as possible to the annotation model of the W3C (https://www.w3.org/TR/annotation-model/)

### Annotation of images

In that case we associate an element of the pivot to the corresponding region on the image. Elements can be : systems, measures, measure/staves and notes/rests/chords.
In order to obtain the regions for all the measures, one can call the following service: 

https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_annotations/image-region/measure-region/
 
### Annotations of audio

These annotations associate an element of the pivot to a time frame in the audio file. Exemple for *Aimons-nous*:

https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_annotations/time-frame/measure-tframe/

### Synchronization

The same element from the pivot score (say, measure M12) appears both in the ``image-region`` annotation (which refers
to a region) and the ``time-frame`` annotation (which refers to a time frame in the audio file).  To summarize, this lets us associate a region on the image and the time frame of the corresponding performance.









