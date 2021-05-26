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

> Let's call these applications 'digital music app' of DMAP (find better) from now on. Typical examples: a (digital) performer (e.g., MIDI performer, 
> or hopefully a more sophisticated one) ; a (digtal) analyser (i.e., a tools that extract some high-level features from a score).

In the following, I list some of these benefits, making the assumption that there is a subset of the data found in a score encoding that 
contains the sufficient and necessary content for most (or all) DMAP. I will call this subset **music content infoset** (waiting for a better term), MCI
for short.

### Benefit 1 : improve entropy

Music score file are often huge, and their structure is extremely complicated (probably because this mix of concerns mentioned above). When such files
are used as input for a DMAP, the amount of noise is great whereas useful content is quite limited. If we could idenfify the MCI and use it as input, the
entropy would be greatly improved, with obvious advantages: 

  - less noise (and probably better quality)
  - clarification on the information really required by DMAPs 
  - opportunity for better structures, higher abstraction levels, possibly algebraic or logic-based manipulations, etc.

### Benefit 2 : less dependence on syntactic idiosyncrasies

There exist many ways to encode a same scores. This does complicate parsing and interpretation of score content. Here, the MCI would act as an abstract level
where encoding practices would disappear in favor of a more uniform representation.

> This issue appeared in the early days of XML when it becames a "language" of choice for data storage and exchange. The W3C felt the need to define the
> so-called "XML information set" [^1] that defines the content of an XML file independently from syntactic variants (e.g., entity dereferencing). The DOM
> is XPath data model are somehow two implementations of the XML infoset, although slightly different.

### Benefit 3: seperation of concerns leads to independent styling

The relevant comparison here is with HTML documents and web layouts. Whereas in the early days (hopefully gone for everybody), HTML contained *both* content 
(e.g., text) *and* presentation instructions, they can now be neatly separatated with core HTML + CSS. In a more general setting,  

## Linked data and MCI


## References

[^1] XML information set. W3C recommendation. https://www.w3.org/TR/2004/REC-xml-infoset-20040204/

