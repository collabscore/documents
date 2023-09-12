# Annotation services

The Saint-Saëns reference collection is identified by all:collabscore:saintsaens-ref.

  - web version is accessible here: http://localhost:8000/home/corpus/all:collabscore:saintsaens-ref/
  - REST services are rooted here: http://localhost:8000/rest/collections/all/collabscore/saintsaens-ref/

The following text gives the main services call to retrieve information on music works (opus).

## Les marins de Kermor

The local ref is C452_0, hence services are rooted at http://localhost:8000/rest/collections/all/collabscore/saintsaens-ref/C452_0/.

### Retrieving annotations

Stats on annotations can be obtained at

http://localhost:8000/rest/collections/all/collabscore/saintsaens-ref/C452_0/_annotations/_stats/

Adding the code of an annotation model gives the statistics per annotation concept. Exemple for the model 'image-region': 

http://localhost:8000/rest/collections/all/collabscore/saintsaens-ref/C452_0/_annotations/image-region/_stats/

Adding the ``_all`` keyword retrieves the list of annotation for the model. 

http://localhost:8000/rest/collections/all/collabscore/saintsaens-ref/C452_0/_annotations/image-region/_all/

In the results, annotations are grouped by the id ot the target element (for instance the measure, or the note).  

The list of annotations can be restricted to a single concept. Example for measure-regions:

http://localhost:8000/rest/collections/all/collabscore/saintsaens-ref/C452_0/_annotations/image-region/_all/
