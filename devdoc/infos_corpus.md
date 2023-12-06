# Gestion du corpus

## Données de l'IRéMus

Les données sont référencées ici: https://docs.google.com/spreadsheets/d/14shI73chgCjkXaEQhOhbi3ICAze1y4uw/edit?pli=1#gid=752663906

Les fichiers eux-mêmes sont récupérables dans un dépôt Github

https://github.com/guillotel-nothmann/Saint-Saens/tree/main/Transcriptions

Dans le dossier ```Transcriptions``` on trouve un sous-dossier par source, avec les fichiers MEI, MusicXML, JSON et Sibelius.

Insertion dans Neuma
====================

Le script ```cp_saintsaens.sh``` (dans ```neuma/scripts```) permet de copier les sources Github dans les données de Neuma. Il prend notamment dans le fichier JSON la référence Gallica et l'insère en tant que source associée dans l'Opus de Neuma.

Il reste à zipper le dossier ```saintsaens``` avant de l'importer dans Neuma. **Attention à bien vérifier la présence du fichier ```corpus.json```**.

  python3 manage.py import_zip -c all:collabscore :f data/composers-datasets/saintsaens  -o mei_as_source

**Ne surtout pas oublier l'option ```mei_as_source```**

Et éventuellement à l'indexer

  python3 manage.py scan_corpus -c all:collabscore:saintsaens -a index

Pour le corpus des sources validées par l'IRéMus (```saintsaens-ref```).  

