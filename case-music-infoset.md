# The case for the modeling of a music (content) infoset
Working draft - Philippe Rigaux (Cnam)

##  What do we find in music score encodings

Current score encodings are based on traditional sheet scores, whose aim is to convey the notation
to performers (or analysts) clearly, efficiently and consistently. Yet, many digital applications that
use these scores as input for other purposes are *not* concerned with details that pertain to (human) readibility. Page
sizes, fonts, margins are useless for a digital performer or a digital analysts. The same can, IMO, be said
for some other aspects, although they seem more tightly related to music notation: allocation of notes to staves, clef,
positionning.

Therefore, my point is the following: *by trying to capture all the eleme,ts that contribute to the final
score layout, digital encodings of scores mix severals concerns of completely distinct nature*. It would
really pay off to *separate these concerns*, with potential benefits for applications that to *not* aim at merely displaying
music notation. More esily said than done, but the challenge is both quite interesting, and may lead to extremely useful achievement.

> Let's call s 'digital music app' of DMAP (find better) from now on the application which are not oriented toward score rendering. 
> Typical examples: a (digital) performer (e.g., MIDI performer, 
> or hopefully a more sophisticated one) ; a (digtal) analyser (i.e., a tools that extract some high-level features from a score);
> music transcription. Some further toughts on these applications are given later.

In the following, I list some of these benefits. Basically, we work on the assumption that there is a subset of the data 
found in score encodings (I will mostly consider MEI)  that 
contains the sufficient and necessary content for most (or all) DMAP. I will call this subset **music content infoset** (waiting for a better term), or MCI  for short.

### Benefit 1 : improve entropy

Music score file are often huge, and their structure is extremely complicated (probably because this mix of concerns mentioned above). When such files
are used as input for a DMAP, the amount of noise is great whereas useful content is quite limited. If we could idenfify the MCI and use it as input, the
entropy would be greatly improved, with obvious advantages: 

  - less noise (and probably better quality)
  - clarification on the information really required by DMAPs 
  - opportunity for better structures, higher abstraction levels, possibly algebraic or logic-based manipulations, etc.

### Benefit 2 : less dependence on syntactic idiosyncrasies

There exist many ways to encode a same scores. This does complicate parsing and interpretation of score content. Here, the MCI would act as an abstract level
where encoding practices would disappear in favor of a more *canonical* representation.

> This issue appeared in the early days of XML when it becames a "language" of choice for data storage and exchange. The W3C felt the need to define the
> so-called [XML information set][1] that defines the content of an XML file independently from syntactic variants (e.g., entity dereferencing). The DOM
> is XPath data model are somehow two implementations of the XML infoset, although slightly different.

### Benefit 3: separation of concerns leads to independent styling

The relevant comparison here is with HTML documents and web layouts. Whereas in the early days (hopefully gone for everybody), HTML contained *both* content 
(e.g., text) *and* presentation instructions, they can now be neatly separatated with core HTML + CSS. In a more general setting,  the same can be said from XML + XSLT.

In the context of music: ideally we could pair some MCI content with one *or many* 'score sheets' with the potentil ability to produce *many* layouts from 
a single content input. There are some quite practical and very useful applications: displaying separately one or several voices ; displaying variants 
or annotations along with a "main" score; transposition, harmonic reductions, etc. There are some touchy issues there (producing socres for separate voices for instance
complies to specific rules and cannot be obtained readily from the general score), but this seems a very exciting and potentially fruitful challenge.

### Benefit 4: better semantics

In principle, if we can "view" a score content as an instance of a well-defined data model, nothing can prevent from defining operations of various kinds,
at an abstrdat, ideally declarative level. This is the approach followed in [time series modelling][2] which proposes a query langugage, but can be declined 
for other situations.

### In summary: the case for a music notation info set, and its impact for linked data

In a project that aims at producing "semantic" data in order to link this data with other sources (annotations), I think it is worth trying to 
identify what is the meaningful content encoded is a score, and model this content. Meaning is necessarily related to applications, and to the set of information
required by these applications. A bet is that there is a common info set that can serve as input to a range of applications, and that we can safely ignore 
any other content embedded in the score which can then simplify considered as noise from the application viewpoint.

Practically speaking, a MEI file for instance would be the source of an instance of MCI, represented in whatever form is suitable (e.g., RDF, JSON-LD, Music21 classes, etc). 
A server would "publish" this instance which could be the source of annotations, transformations, or any process (musicological analysis for instance) thta requires
as input a clean and well structured representation of music notational content. 

## Examples 

### Example 1: from notation to performance and vice-versa

### Example 2: styling score sheets

## Preliminary thoughts





## References

[1]:  <https://www.w3.org/TR/2004/REC-xml-infoset-20040204>(XML information set. W3C recommendation.)

[2]: <https://hal.archives-ouvertes.fr/hal-02454536>(Fournier-S'niehotta, R.; Rigaux, P. and Travers, N. Modeling Music as Synchronized Time Series: Application to Music Score Collections. In Information Systems, 73: 35-49, 2018)

[3]: <https://hal.archives-ouvertes.fr/hal-02454536>(Cherfi, S. S-s.; Guillotel, C.; Hamdi, F. c.; Rigaux, P. and Travers, N. Ontology-Based Annotation of Music Scores. In Knowledge Capture Conference, pages 1-4, ACM Press, Austin, 2017.)
