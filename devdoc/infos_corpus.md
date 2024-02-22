# Gestion du corpus

## Données de l'IRéMus

Les données sont référencées ici: https://docs.google.com/spreadsheets/d/14shI73chgCjkXaEQhOhbi3ICAze1y4uw/edit?pli=1#gid=752663906

Les fichiers eux-mêmes sont récupérables dans un dépôt Github

https://github.com/guillotel-nothmann/Saint-Saens/tree/main/Transcriptions

Dans le dossier ```Transcriptions``` on trouve un sous-dossier par source, avec les fichiers MEI, MusicXML, JSON et Sibelius.

### Insertion dans Neuma

Le script ```cp_saintsaens.sh``` (dans ```neuma/scripts```) permet de copier les sources Github dans les données de Neuma. Il prend notamment dans le fichier JSON la référence Gallica et l'insère en tant que source associée dans l'Opus de Neuma.

Il reste à zipper le dossier ```saintsaens``` avant de l'importer dans Neuma. **Attention à bien vérifier la présence du fichier ```corpus.json```**.

  python3 manage.py import_zip -c all:collabscore -f data/composers-datasets/saintsaens.zip  -o mei_as_source

**Ne surtout pas oublier l'option ```mei_as_source```**

Et éventuellement à l'indexer

  python3 manage.py scan_corpus -c all:collabscore:saintsaens -a index

### Le corpus de référence

Ce sont les documents validées par l'IRéMus, donc en vert dans le tableur.

 - C006_0, dans les coins bleus
 - C009_0, fière beauté
 - C010_0, God save the King
 - C013_0, La sérénité
 - C024_0, chanson triste
 - C035_0, avril
 - C036_0, l'amour blessé
 - C046_0, clair de lune
 - C079_0, la coccinelle
 - C080_0, la feuille de peuplier
 - C141_0, guitare
 - C437_0, deux chœurs, calme des nuits
 - C452_0, les marins de Kermor
 - C455_0, Ode d'Horace
 - R165_0, Suite (?, en bleu?)
 - R171_0, Danse macabre (mélodie)
 - R171_3, Danse macabre, poème symphonique


