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
l'adaptation de ces composants à l'architecture CollabScore. À court terme, on vise donc les résultats suivants:
 
  1. Le Cnam et l'IRémus fournissent une liste de partitions pivots MEI disponibles sur Neuma (http:///neuma.huma-num.fr)
     associées à des enregistrements (YouTube en priorité, autre sources éventuellement).
  2. Le Cnam transmet à Algomus les spécifications d'une interface REST permettant de déposer sous forme d'annotation
     la correspondance entre un élément de la partition pivot (une mesure) et un fragment temporel dans la source YouTube.
  3. Algomus fournira une interface permettant de lire en mode synchronisé la partition pivot (p.e. avec Verovio) et 
     le fragment YouTube.  Cette interface s'appuiera sur les données précédents récupérées en lecture via les services REST. 
    
 Note PR: un graphiste / ergonome est disponible pour nous conseiller sur les interfaces de visualisation et réaliser les
 composants graphiques nécessaires (CSS, autres).
