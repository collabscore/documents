# The case for the modeling of a music (content) infoset
Philippe Rigaux (Cnam)

##  What do we find in music score encodings

Current score encodings are based on traditional sheet scores, whose aim is to convey the notation
to performers (or analysts) clearly, efficiently and consistently. Yet, many applications that
use these scores as input are *not* concerned with details that pertains to (human) readibility. Page
sizes, fonts, margins are useless for a digital performer or a digital analysts. The same can, IMO, be said
to some aspects which seem more tightly related to music notation: allocation of parts to staves, and clef.

Therefore, I think that digital encoding of scores mix severals concerns of distinct nature, and that it would
really pay off to *separate* these concerns, with potential benefits for applications that to *not* aim at merely displaying
music notation.

> Let's call these applications 'digital music app' from now on. Typical examples: a (digital) performer (e.g., MIDI  

 - Improve entropy:

designed for rendering and exchange purposes, and cannot directly be exploited
as instances of a clear data model supporting algebraic manipulations. We propose
an approach that leverages a music content model hidden in score notation, and define
a set of composable operations to derive new ``scores''  from a corpus of existing ones.
We show that this approach supplies a high-level tool to express common, 
useful applications, and
can easily be implemented on top of standard components. 
