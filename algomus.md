# Notes sur les tâches AlgoMus

## Réunion du 4 octobre 2022

Présents: Philippe, Mathieu, Charles, Emmanuel

Présentation à Charles des objectifs du projet et de l'architecture CollabScore baséee sur services REST pour accéder à des documents MEI, et créer / lire 
des annotations sur ces documents. Cf. https://github.com/collabscore/documents/blob/main/architecture.md

L'équipe algomus est chargée des interfaces de synchronisation permettant de visualiser en parallèle des documents 
multimédia relatifs à une œuvre musicale. La représentation de référence de cette œuvre est un document MEI (dite partition pivot)
obtenu 
(au moins initialement) par reconnaissance optique (tâches IRISA), et fournissant des identifiants stables pour tous
les composants de la partition: mesures, systèmes, notes, etc. La synchronisation s'appuie sur des annotations qui lient
ces composants à des fragments de documents multimédia: région dans une image, fragment temporel dans un document audio ou
vidéo, identifiant d'un élément dans un document XML.

### Synchronisation audio / MEI

AlgoMus dispose déjà de composants mûrs pour lier une partition pivot et un fragment audio. La première cible est donc 
l'adaptation de ces composants à larchitecture CollabScofer
