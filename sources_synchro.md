# Synchronization of sources

This documents explains the data organization and services that allows to synchronizes
the *sources* of an *opus*.

## Opus and sources

An Opus in Neuma is a music work associated to digital representations of this work in various formats,
called *sources*. Some sources represent the music score, either in MusicXML or MEI (there should
always be one such source). Others represent images of a score edition, performances, or event texts 
related to the source.

An opus is identified by an absolute path in the tree Neuma of collections (called *corpus*). 
In the following, we illustrate
the synchronization of sources on a music melody by Saint-Saëns, "Aimons-nous". Its id is 
``all:collabscore:saintsaens-audio:C055_0`` (meaning that it is stored in the ``saintsaens-audio`` 
corpus, itself stored in the ``collabscore`` corpus. The local id of the piece in ``saintsaens-audio``
is ``C055_0``.

In the web interface of Neuma, the piece and its sources can be inspected at https://home/opus/all:collabscore:saintsaens-audio:C055_0/.
From now on, we will focus on REST services.

## Services

A JSON representation of the Opus can be obtained at
https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0

We can more precisely inspect the list of sources with the following service.

https://neuma.huma-num.fr/rest/collections/all:collabscore:saintsaens-audio:C055_0/_sources/







