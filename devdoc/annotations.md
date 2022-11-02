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
  - a *style* (optional) for display purposes
 
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

### Annotation model, concepts and style

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
It will be elaborated soon.

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
 - a simpled text ("Textual body" in the W3C model)

### Creator

The creator of an annotation is a triplet ``(id, type, name)`` where ``type``is either 
``Person`` or ``Software``.


# JSON serialization

In JSON-LD, this *could be* represented by the following document: 


```json
{
  "@context": "http://www.w3.org/ns/anno.jsonld",
  "id": "http://collabscore.org/anno1",
  "type": "Annotation",
  "creator": "createur",
  "created": "2021-01-28",
  "modified": "2021-05-29",
  "body": "http://serveurIIIF/imgdir/12,50,90,56/max/0/default.jpg",
  "target": "http://collabscore/mapartition.mei#xpath(id('m-57'))"
}
```
