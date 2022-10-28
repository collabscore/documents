# Managing annotations in CollabScore

CollabScore manages interlinked *multimodal* representations of music items, called *multimodal scores* (*mscore* for short). A mscore consists of:

 - A *pivot score* is an encoding of a music piece content based on music notation concepts. In practice, a pscore is a MEI document where *all* elements (measures, notes, rests, cleefs, etc.) are uniquely identified  and thus can be referred to by URIs.
 - One or several *sources*, i.e. multimedia documents that instantiate a representation of the music  item in a specific format: audio, video, image, XML encoding, etc.
 - *Annotations* that associate  elements of the pivot score to fragments of each source.
 
![Multimodal score](/figures/partitionMM.png)

The following focuses on annotations. 

##  Annotations

We comply as much as possible to the annotation model of the W3C (https://www.w3.org/TR/annotation-model/). In particular, web services of CollabScore exchange annotations serialized in JSON-LD.

### Principles

In this model, an element of the pscore is annotated and constitutes the *target* of the annotation. 
What is said about this target is the annotation *body*. Let's take an example: we want 
to represent as an annotation the fact that a measure in the pscore corresponds to a region in
an image source. Then:
 
    - The *target* is the URL that leads to the annotated measure in the MEI document of the pscore.
    - The *body* is the URL that refers to the part of the source image covered by the region.

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
