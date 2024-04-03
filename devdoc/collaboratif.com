# Spécifications de l'interface collaborative

## Organisation des campagnes en 4 étapes

Les campagnes se succèdent dans un ordre strict. 
  
Chaque campagne s'effectue à une certaine granularité et produit une séquence d'opérations d'éditions.

Après chaque campagne on recalcule le MEI à partir de la sortie OMR et des opérations
d'édition.
  
### Première étape - Manifeste

On spécifie les parties: instruments, abbréviations (granularité: Opus)

On associe chaque portée (simple ou double) à l'une des parties (granularité : page)

Opérations d'édition:
  # specify_part (décrire une partie) 
  # merge_staves (fusionner 2, voire 3 portées sur une même partie)
  # assign_staff_to part 

### Phase 2 - Contexte interprétation

Granularité : page

 - Armures 
 - Clef (en cas de niveau de confiance assez faible)
 - Métrique (en cas de doute sur la durée de la mesure)

Phase 3 - Locaux

Granularité page 

  - Durée, hauteur, altération, 

Phase 4 - optionnelle 

Lecture globale -> lyrics avec saisie en séquentiel comme 
dans MuseScore
