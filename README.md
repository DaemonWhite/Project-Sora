# Project Sora
 RPG Openworld en dark fantaisie

# Somaire
- [Contribuer](#pour-la-contribution)
- [Conduite du code](#conduite-du-code)
- [Architecture du projet](#architecture-du-projet)

# Pour la contribution
Pour contribuer au projet penser a respecter des nom de commit correcte
```
Titre: Ajout: switch caméra
Description : "Permet de passer d'une caméra à une autres facilement"
```

Il faudra aussi créer des branches qui suive la même logique si on veut créer un système de caméra on créera une branche caméra. Une fois quelle est prêtes on enverras une merge Request est un autre membre analysera pour plus de sureter

Pour plus de détaille sur la contribution voir [ICI](CONTRIBUTING.md)

# Conduite du code
Pour l'écriture du code il y'a pas mal de chose à prendre en compte pour commencer il faut ce référencer à la [doc](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdscript/gdscript_styleguide.html) c'elle ci nous indique comment bien respecter la syntaxe. 

Il est aussi très important de documenter sont code.

> [!CAUTION] 
> Si vous ne le faite pas je viens vous attaquer.
  >
> Plus sérieusement il est important dans un travaille de groupe de comprendre comment fonctionne le travaille des autres.
> Si vous ne documenter pas vous faite perdre du temps à tout le monde mais aussi à votre vous du futur. 

Il est aussi important à noter que les variables et méthode doives avoirs des noms anglais example

```gdscript
var camera_premiere_persone # Pas bien
var first_person_camera # C'est bien
```

Un autre point intéressant et l'ordre de nommage par example
```gdscript
var camera_first_person # Pas bien
var first_person_camera # Bien
```

> [!NOTE]
> Le premier mot de la variable doit êtres le demarqueur alors que le dernier dois êtres le commun. Il n'est pas très grace si

Une autre règles à respecter et que les nom de classe dans un fichier doit correspondre au nom du fichier. Exemple : 

> [!IMPORTANT]
> Class_name -> FirstCamera
  >
> file -> first_camera.gd

pour plus de détaille référer vous à [code_of_conduite](code_of_conduct.md)

# Architecture du projet
Le projet suivra l'aboressance suivante
```sh
/models/ # Les models 3ds Sont stocker ICI
/scenes/ # Les scène sont stocker ICI
/scripts/ # Les scripts sont stocker ICI
/textures/ # Les textures sont stocker ICI
```

Pour plus de détaille sur larboressance de chacun référer vous à leurs doc

- [Models](Models/README.md)
- [Scenes](Scenes/README.md)
- [Scripts](Scripts/README.md)
- [Textures](Textures/README.md)