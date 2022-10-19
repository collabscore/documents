# CollabScore services

CollabScore proposes a RESTful interface to communicate with the digital library. 
All documents exchanged are JSON-encoded.  All services are rooted at http://neuma.huma-num.fr/rest

The main objects to interact with are

 - *Pivot scores*, or *pscore* in short: a MEI-encoded music score, linked to *sources* via *annotations*
 - *Collections*: like directories in file systems ; a collection contains pscore and/or sub-collections.

Collections and pscores are uniquely identified with an *id* which takes the form ``Ci:Cj:...:R``.
An id is built from the sequence of collection ids from the root (named ``all``) to the resource ``R``, 
separated by semicolons. For instance 

 - the id of the CollabScore collection  is ``all:collabscore``
 - the id of the basic sample file ``dmos_ex1`` pscore in CollabScore is ``all:collabscore:dmos_ex1``

One can interact with a pscore either with a Web interface or with the Restful interface. Examples for the Web interface:

 - Collection CollabScore can be consulted (and edited for authorized users) at http://neuma.huma-num.fr/home/corpus/all:collabscore/
 - Pscore ``dmos_ex1`` can be consulted (and edited for authorized users) at http://neuma.huma-num.fr/home/opus/all:collabscore:dmos_ex1/

Example for the REST interface 

 - Collection CollabScore can be consulted at http://neuma.huma-num.fr/rest/collections/all:collabscore/, 
 - Its set of pscores is at http://neuma.huma-num.fr/rest/collections/all:collabscore/_opera/
 - A specific pscore such as ``dmos_ex1`` is accessible at: http://neuma.huma-num.fr/rest/collections/all:collabscore:dmos_ex1/

In this document, we document the set of web services useful to CollabScore. A Swagger interface with all services is
available at http://neuma.huma-num.fr/rest/swagger/.

## Getting collections and pscores

Given a collection, you can retrieve the list of sub-collections with the ``_corpora``
service. The sub-collections of CollabScore are obtained by calling the service:

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore/_corpora/
```

The list of pscores in a collection is obtained with the ``_opera`` service.

```
curl -X GET http://neuma.huma-num.fr/rest/collections/all:collabscore/_opera/
```

The meta-description of a pscore is obtained 

http://neuma.huma-num.fr/rest/collections/all:collabscore:dmos_ex1/
A pscore is associated  MusicXML document, the MEI document, the PDF and PNG 
rendering obtained from Lilypond, etc. You can check the list of files available 
with the <tt>_files</tt> Opus service.
</p>

<code>
curl -X GET "/rest/collections/psautiers/godeau1656/1/_files" 
</code>

<p>
Test it: <a href="{{NEUMA_URL}}/collections/psautiers/godeau1656/1/_files" target="_blank">/rest/collections/psautiers/godeau1656/1/_files</a>.
</p>
<p>
Here is the list of possible files names.
<ol>
<li><tt>score.xml</tt>. The MusicXML document.</li>
<li><tt>mei.xml</tt>. The MEI document.</li>
<li><tt>score.ly</tt>. The Lilypond document.</li>
</ol>


