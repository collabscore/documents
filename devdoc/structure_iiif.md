
# Structure des fichiers IIIF

## En V3

### Les types de base

Les *chaines de caractères* ont une représentation un peu compliquée: c'est un dictionnaire dont les clés sont la langue, et la valeur un tableau de chaînes de caractères. Un exemple vaut mieux :

```JSON
{
    "fr": [
      "Pelléas, Acte II, scène 1"
    ]
  }
```

