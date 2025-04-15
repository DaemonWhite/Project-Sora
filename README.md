# Project Sora
 RPG Openworld en dark fantaisie

# Somaire
- [Contribuer](#pour-la-contribution)
- [Conduite du code](#conduite-du-code)
- [Architecture du projet](#architecture-du-projet)

# Pour la contribution
Pour contribuer au projet pensez à respecter des noms de commit correcte
```
Titre: Ajout: switch caméra
Description : "Permet de passer d'une caméra à une autre facilement"
```

Il faudra aussi créer des branches qui suivent la même logique si on veut créer un système de caméra on créera une branche caméra. Une fois qu'elle est prêtes on enverra une merge Request est un autre membre analysera pour plus de sûreté

Pour plus de détaille sur la contribution voir [ICI](CONTRIBUTING.md)

# Conduite du code
Pour l'écriture du code il y'a pas mal de chose à prendre en compte pour commencer il faut ce référencer à la [doc](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdscript/gdscript_styleguide.html) celle-ci nous indique comment bien respecter la syntaxe. 

Il est aussi très important de documenter son code.

> [!CAUTION] 
> Si vous ne le faites pas je viens vous attaquer.
  >
> Plus sérieusement il est important dans un travaille de groupe de comprendre comment fonctionne le travaille des autres.
> Si vous ne documenter pas vous faites perdre du temps à tout le monde mais aussi à votre vous du futur. 

Il est aussi important à noter que les variables et méthodes doivent avoir des noms anglais example :

```gdscript
var camera_premiere_persone # Pas bien
var first_person_camera # C'est bien
```

Un autre point intéressant est l'ordre de nommage par example :
```gdscript
var camera_first_person # Pas bien
var first_person_camera # Bien
```

> [!NOTE]
> Le premier mot de la variable doit êtres le demarqueur alors que le dernier dois êtres le commun.

Une autre règles à respecter et que les nom de classe dans un fichier doit correspondre au nom du fichier. Exemple : 

> [!IMPORTANT]
> Class_name -> FirstCamera
  >
> file -> first_camera.gd

pour plus de détaille référer vous à [conduite du code](CODE_OF_CONDUCT.md)

# Architecture du projet
Le projet suivra l'arborescence suivante :
```sh
/models/ # Les models 3ds Sont stocker ICI
/scenes/ # Les scène sont stocker ICI
/scripts/ # Les scripts sont stocker ICI
/textures/ # Les textures sont stocker ICI
```

Pour plus de détaille sur l'arborescence de chacun référer vous à leurs docs :

- [Models](Models/README.md)
- [Scenes](Scenes/README.md)
- [Scripts](Scripts/README.md)
- [Textures](Textures/README.md)
