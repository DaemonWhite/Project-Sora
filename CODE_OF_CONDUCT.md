# La conduite du Code
Ici on verras comment écrire le code et l'organiser.

Avant toute chose lisez la doc officielle de GDScript et GDExtention. Et celle aussi pour Documenter votre code 

## Sommaire

- [Comment nommez ?](#comment_nommez_?)
- [GDScript](#gdscript)
- [GDExtention](#gdxtention)

## Comment nommer ?

> [!WARNING]
> Dans le cas des exemples on utilisera parfois des noms de variables Français mais dans notre code que l'anglais.
> 
> Si il y a du franglais alors il sera demandez de le renommer à la revue du code

#### Comment nommez les variables
Pour nommer les variables il suffit juste de dire ce quelle représentes.


> Contexte on créé une variable pour le déplacement du personage


Exemple
```gdscript
var movement_character # Nom très bien
var movement # Nom bien (Si il y a plusieurs move pas bien)
var move # Action directe
var mv # Pas bien
```

Rien de compliqué non ?

> [!IMPORTANT]
> Pour nommez une variable il vaut mieux utiliser un adverbe qui représente indirectement une action. Ce n'est pas la variable qui déplace le personnage mais la méthode

> [!TIP]
> L'astuce pour trouver un nom de variable c'est de dire à quoi il représente par exemple la variable sert à déplacer un personnage donc `deplace_personage`
> 
> On peut simplifier la chose comme-ci `action_indirect_pour`
> 
> A noter aussi qu'il existe parfois des thermes plus adapter si on reste dans notre exemple velocity serait mieux que movement

> [!CAUTION]
> Il est important de noter que des noms de variables non Judicieux ne passera pas à la revue

#### Comment nommer les méthodes

Pour nommer une méthode c'est très similaire aux variables il suffit juste de dire ce quelle execute.

> Contexte on créé une méthode pour le déplacement du personage

```gdscript
move_character() # Très bien
move() # Si seul Très bien, autrement bien
Move() # Pas bien pas de majuscule
moveCharcter() # Pas bien car il y a une majuscule
mv() # Pas bien
```

Rien de compliqué non ?

> [!IMPORTANT]
> Pour nommer une méthode il vaut mieux utiliser un verbe qui représente directement une action. 

> [!TIP]
> L'astuce pour trouver un nom de méthode c'est de dire à quoi il représente par exemple la variable sert à déplacer un personnage donc `deplacer_le_personage`
> 
> On peut simplifier la chose comme-ci `action_direct_pour`
> 
> A noter qu'il est interessant de garder un liens directe entre le nom de la variables et le nom de la méthodes. Plus facile à faire en français qu'en anglais je sais.

> [!CAUTION]
> Il est important de noter que des noms de méthodes non Judicieux ne passera pas à la revue

#### Comment nommer les classes

Le nommage des classes est l'inverse du nommage des variables on commance par Qui et on finis par sa fonction. 

Contexte imaginons qu'on crée un manipulateur de camera.

```gdscript
class_name CameraHandler # Très Bien
class_name HandlerCamera # Pas Bien
```

Imaginons que l'on créé des classes qui hérites les une des autres par example pour le déplacement des personages

Pas Bien
```gdscript
BaseMoveCharacter
SimpleMoveCharacter
```

Bien
```gdscript
CharacterMoveBase
CharacterMoveSimple
```

> [!NOTE]
> Si les classes sont inversé c'est pour que l'on retouve plus facilement les variants de cettes classe (Enfant et Parent) mais aussi car ce ne sont pas des actions mais des definitions de quelqu'un ou quelque chose.
> 
> Il est donc plus aisée de présenter en premier de qui on parle et de son rôle après

## Quand utiliser GDScript et GDExtention
- GDScript est réservé au code simple qu nécessite pas mal de perfomance. On l'utilisera aussi pour prototiper des éléments qu'on réécrira au moment voulu en GDExtention
-  GDExtention est réservé à la partie performance du code tout ce qui est physique.

## GDScript
### Avant de commencer
- Lire [GDScript Style](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdscript/index.html) vous dis comment écrire votre code
- Lire [GDScript Réfèrence](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdscript/gdscript_basics.html) vous explique les particularités du language 
- Lire [GDScript Properties](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdscript/gdscript_exports.html) vous servira pour avoir un affichage propre dans la vue 3D

> [!WARNING]
> Ne réinventer pas la roue et priviligié les méthodes de GDScript pour les calculs ou autres.
> 
> Il y'a deux raisons à ça :
> 
> La première c'est la fainéantise il ne faut pas réinventer la roue
> 
> La deuxièmes c'est la rapidité GDScript est très lent. Donc même si d'un point de vue algo votre code est meilleurs. Il risque d'étres plus performant d'utiliser les méthodes de GDScript qui pointe vers du c++
> 
> Si jamais il y'a pas d'autre choix il sera donc plus pertinant d'utiliser [GDExtention](#gdxtention)

### Typage
Dans gdscipt le typage est dynamique c'est sympatique car ça donne beaucoup plus de flexibilité. Là ou ces mauvais c'est que ça peut réduire la compréhention du code.

C'est pour cela qu'il faut au maximum typer avec son langage. 
Une autre raison de typer le langage c'est la performance car l'ordinateur vas perdre quelques ms secondes à trouver le bon type

Voici un example de typage de variable
```gdscript
var une_variable: Variant = "coucou" # Typage automatique forcé
var une_variable: = "coucou" # Typage automatique
var un_string_variant: String = "coucou" # Typage dynamique
```

Voici un example de typage en fonction
```gdscript
func addition(a: float, b:float) -> float:
	return (a+b)
```

Imaginons maitenant que l'on veut stocker quelque chose de quelconque. Ici on pourrais ce dire super j'ai pas à typer et bah non il faudra quand même mettre le type `Variant`

```gdscript
var array: Array

func ajout_quelquonque(add: Variant):
	array.push_back(add)
```

## GDExtention
### Avant de commencer
> [!WARNING]
> GDExtention c++ à très peu de documentation

- lire [GDExtention c++](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdextension/index.html) 

> [!WARNING]
> Comming Soon

## Documentation
### Différences entre commentaire et documentation

#### Comentaire
> Un commentaire est une explication qui vise à expliquer un petit bout du code qui n'est guère aisez de comprendre à vue d'oeil. Il s'addresse à vos collègues ou à votre vous du futur qui aurras besoins d'apporter des modifications sur ce même code

#### Documentation
> La documentation s'adresse à ce qui vont utiliser vos méthodes ou classes il est là pour apporter des exemples concret ou des expliquations, des éléments mis à dispostion de l'utilisateur de votre classe.
> 
> La documentation est principalement utile pour un travail d'équipe. Elle évite au gens de regarder votre code pour comprendre comment s'en servir.

#### Pour Conclure
Le commentaire est la pour expliquer des éléments succins pour ceux qui créé la classe

La documentation est la pour expliquer le fonctionement de votre classe à ceux qui vont l'utiliser

### Bien documenter
Pour bien documenter il faut d'abord créer une phrase d'introduction qui explique de manières sucinte le rôle d'une méthode.

Après si besoin on peut rajouter des détailles sur le fonctionement ou le liens avec X ou Y éléments.

> [!TIP]
> Si malgrés l'explication il reste dificile de comprendre comment utiliser votre classe il est pas mal de mettre un exemple concret avec des codeblock
