# Notes réunions CollabScore

## Réunion pleinière, 8 juin 2022

(Notes S. Cretin)

Ordre du jour :

  - Présentation de l’état actuel d’avancement (serveur CollabScore, procédure d’import de l’OMR, système d’annotation) ; NB : le projet a pris entre 6 mois et 1 an de retard.
  - Présentation par Algomus (nouveau partenaire) des outils actuels de synchronisation multimedia.
  - Actions à lancer d'ici fin 2022.

### Outil OMR : DMOS (IRISA)

Format d'export : MEI ; encodage des éléments musicaux + annotations : identification de l'image omrisée, coordonnées des boîtes, erreurs et questions du moteur OMR... Ces annotations sont récupérables au format json ; elles seront exploitées pour la correction collaborative et par les outils de synchronisation multimedia. Le moteur OMR est à l'état de prototype : non complètement fonctionnel (exemple : absence des coordonnées matricielles des boîtes dans le MEI). Des développements coordonnés par l'IRISA sont à venir.

### Algomus (http://www.algomus.fr/)

Ils ont déjà développé des solutions de synchronisation multimedia (alignement partition encodée-pivot / partition image / audio ou vidéo), mais qui ne reposent pas sur MEI (enjeu aussi autour de l'exploitation de l'attribut xml id des notes encodées). Développements à venir.

### Actions côté BnF

- Produire les spécifications de la plateforme de correction collaborative (développée par le CNAM).
- Fournir les images pour environ 500 partitions de Saint-Saëns.

Pour préparer cette mise à disposition, voici pour 1 partition de Saint-Saëns prise au hasard (https://gallica.bnf.fr/ark:/12148/bpt6k1170231k, 20 vues), les dimensions en pixels des images récupérées via IIIF (jpg) et via la Chaîne de mise à disposition de la BnF (tif). Vous constaterez que ces dimensions sont (quasi) identiques. Ceux ou celles parmi vous qui souhaiteraient recevoir les images pour comparaison peuvent se signaler par retour de mail.

## Réunion du 4 octobre 2022, Cnam - AlgoMus

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
