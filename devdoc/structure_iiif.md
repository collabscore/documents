
# Structure des manifestes IIIF (V3)

Un *manifeste* est un document JSON décrivant une source multimédia (image, audio, vidéo, texte...). En simplifiant, un manifeste est une séquence de *canevas*, eux-mêmes
constitués d'une liste d'objets (images, autres). À tous les niveaux, les
objets d'un manifeste peuvent faire l'objet d'annotations donnant des
informations complémentaires ou des liens vers d'autres objets.

La documentation complèe se trouve ici: https://iiif.io/api/presentation/3.0/

## Les métadonnées et autres informations descriptives

### Les chaines de caractères

Les *chaines de caractères* ont une représentation un peu compliquée: c'est un dictionnaire dont les clés sont la langue, et la valeur un tableau de chaînes de caractères. Un exemple vaut mieux qu'une longue explication:

```JSON
{
    "fr": [
      "Pelléas, Acte II, scène 1"
    ]
  }
```
### Les images

Les images sont représentées par des éléments de type ``Image``. Quand c'est possible
elles correspondent à un service IIIF. Voici un exemple d'image sur le serveur IIIF du Cnam:
```JSON
"thumbnail": {
      "id": "https://deptfod.cnam.fr/ImageS/iiif/2/imgs%2Fcimetiere/full/max/0/default.jpg",
      "type": "Image",
      "height": 1764,
      "width": 3158,
      "service": [
        {
          "id": "https://deptfod.cnam.fr/ImageS/iiif/2/imgs%2Fcimetiere",
          "type": "ImageService3"
        }
      ],
      "format": "image/jpeg"
    }
```
On trouve donc:
  - l'id: c'est une URL permettant d'accéder à une représentation de l'image (ici la représentation complète)
  - la hauteur et la largeur
  - le format
  - et un sous-objet ``service``   qui indique que des services IIIF de transformation (conformes au protocole IIIF ImageService3) peuvent être demandés ; l'id est l'adresse du service.

Quelques exemples de transformation d'image à partir du service
   - rotation à 90° https://deptfod.cnam.fr/ImageS/iiif/2/imgs%2Fcimetiere/full/max/90/default.jpg
   - extraction d'une région: https://deptfod.cnam.fr/ImageS/iiif/2/imgs%2Fcimetiere/35,25,1000,300/max/0/default.jpg
   - taille réduite à 20%: https://deptfod.cnam.fr/ImageS/iiif/2/imgs%2Fcimetiere/full/pct:20/0/default.jpg



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

## Structure des manifestes combinés audio/image

Un manifeste combiné audio/image contient un unique canevas. Le manifeste 
contient les champs ``label``, ``summary`` et ``metadata``, comme
expliqué ci-dessus. Le canevas ne contient pas de données descriptives.

Les objets du canevas sont
  - un *item* correspondant au fichier audio ou vidéo, avec sa durée
  - un *item* pour chaque image, l'URL indiquant la période d'affichage de l'image par rapport au fichier audio/vidéo

Chaque *item* contient des propriétés ``label`` et ``summary``.

Exemple d'*item* pour l'audio ou la vidéo (noter le type)

```JSON
           {
              "id": "http://neuma.huma-num.fr/all:collabscore:royaumont:pelleas_2_1/video",
              "type": "Annotation",
              "label": {
                "fr": [
                  "Source audio/vidéo"
                ]
              },
              "motivation": "painting",
              "body": {
                "id": "https://mediaserver.lecnam.net/downloads/file/v126b0e715b7fx9wxgc4/?url=media_1080_9iBked9mBA.mp4",
                "type": "Video",
                "duration": 466,
                "format": "video/mpeg"
              },
              "target": "http://neuma.huma-num.fr/all:collabscore:royaumont:pelleas_2_1/canvas",
              "summary": {
                "fr": [
                  "Source audio Royaumont"
                ]
              }
            }
```


Exemple d'*item* pour les images (noter l'intervalle temporelle dans ``target``).

```JSON
          {
              "id": "http://neuma.huma-num.fr/all:collabscore:royaumont:pelleas_2_1/img1",
              "type": "Annotation",
              "label": {
                "fr": [
                  "Page 1"
                ]
              },
              "motivation": "painting",
              "body": {
                "id": "https://deptfod.cnam.fr/ImageS/iiif/2/pelleasa2s1%2F048/full/full/0/default.jpg",
                "type": "Image",
                "height": 3780,
                "width": 2898,
                "format": "image/jpeg"
              },
              "target": "http://neuma.huma-num.fr/all:collabscore:royaumont:pelleas_2_1/canvas#t=0,45.124717",
              "summary": {
                "fr": [
                  "Source IIIF bibliothèque Royaumont"
                ]
              }
            }
```
