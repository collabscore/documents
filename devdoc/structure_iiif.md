
# Structure des manifestes IIIF

Un *manifeste* est un document JSON décrivant une source multimédia (image, audio, vidéo, texte...). En simplifiant, un manifeste est une séquence de *canevas*, eux-mêmes
constitués d'une liste d'objets (images, autres). À tous les niveaux, les
objets d'un manifeste peuvent faire l'objet d'annotations donnant des
informations complémentaires ou des liens vers d'autres objets.

## En V3

La documentation complèe se trouve ici: https://iiif.io/api/presentation/3.0/

### Les chaines de caractères

Les *chaines de caractères* ont une représentation un peu compliquée: c'est un dictionnaire dont les clés sont la langue, et la valeur un tableau de chaînes de caractères. Un exemple vaut mieux qu'une longue explication:

```JSON
{
    "fr": [
      "Pelléas, Acte II, scène 1"
    ]
  }
```

### Propriétés descriptives

Chaque objet d'un manifeste peut être accompagné d'un ensemble de propriétés
descriptives:
   - un *label*, texte court qui peut être utilisé pour désigner l'objet (par exemple le titre d'une œuvre ou le numéro d'une page)
   - un *summary*, description plus ou moins longue de l'objet
   - une liste de *metadonnées*, par exemple le titre, l'auteur, la licence, etc.
 
Les propriétés *label* et *summary* sont des chaînes de caractères selon le 
format ci-dessus. Exemple:

```JSON
  "id": "http://neuma.huma-num.fr/all:collabscore:royaumont:pelleas_2_1",
  "type": "Manifest",
  "label": {
    "fr": [
      "Pelléas, Acte II, scène 1"
    ]
  },
  "summary": {
    "fr": [
      "Texte de description de l'œuvre"
    ]
  },
```
Pour les métadonnées c'est plus compliqué: liste de paires (clé, valeur), 
la clé et la valeur elles-mêmes étant des chaines IIIF.

Exemple:

```JSON
"metadata": [
    {
      "label": {
        "fr": [
          "title"
        ]
      },
      "value": {
        "fr": [
          "Pelléas, Acte II, scène 1"
        ]
      }
    },
    {
      "label": {
        "fr": [
          "creator"
        ]
      },
      "value": {
        "fr": [
          "Claude  Debussy (1868, 1918)"
        ]
      }
    }
  ]
```

