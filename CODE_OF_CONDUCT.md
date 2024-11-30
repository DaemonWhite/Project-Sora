# La conduite du Code
Ici on verras comment ecrire le code et l'organiser.

Avant toute chose lisez la doc officielle de GDScript et GDExtention. Et celle aussi pour Documenter votre code 

## Sommaire

- [Comment nommez ?](#comment_nommez_?)
- [GDScript](#gdscript)
- [GDExtention](#gdxtention)

## Comment nommez ?

> [!WARNING]
> Dans le cas des examples on utilisera parfois des noms de variables Français mais dans notre code que l'anglas.
> 
> Si franglais alors il cera demandez de le renommez à la revue du code

#### Comment nommez les variables
Pour nommer les variables il suffit juste de dire ce quelle représentes.


> Contexte on crée une variable pour le déplacement du personage


Exemple
```gdscript
var movement_character # Nom très bien
var movement # Nom bien (Si il y'a plusieurs move pas bien)
var move # Action directe
var mv # Pas bien
```

Rien de compliquer non ?

> [!IMPORTANT]
> Pour nommez une variable il vaut mieux utiliser un adverbe qui représente in directement une action. Ce n'est pas la variable qui déplace le perssonage mais la méthode

> [!TIP]
> L'astuce pour trouver un nom de variable c'est de dire à quoi il représente par exemple la variable sert à déplacer un personnage donc `deplace_personage`
> 
> On peut simplifier la chose comme-ci `action_indirect_pour`
> 
> A noter aussi qu'il existe parfois des thermes plus adapter si on reste dans notre exemple velocity cerait mieu que movement

> [!CAUTION]
> Il est important de notez que des nom de variables non Judicieux ne passera pas à la revue

#### Comment nommer les méthodes

Pour nommer une méthode c'est très similaire aux variables il suffit juste de dire ce quelle execute.

> Contexte on crée une méthode pour le déplacement du personage

```gdscript
move_character() # Très bien
move() # Si seul Très bien autrement bien
Move() # Pas bien pas de majuscule
moveCharcter() # Pas bien car majuscule
mv() # Pas bien
```

Rien de compliquer non ?

> [!IMPORTANT]
> Pour nommez une méthode il vaut mieux utiliser un verbe qui représente directement une action. 

> [!TIP]
> L'astuce pour trouver un nom de méthode c'est de dire à quoi il représente par exemple la variable sert à déplacer un personnage donc `deplacer_le_personage`
> 
> On peut simplifier la chose comme-ci `action_direct_pour`
> 
> A noter qu'il est interessant de garder un liens directe entre le nom de la variables et le nom de la méthodes. Plus facile à faire en françaui qu'en anglais je sais

> [!CAUTION]
> Il est important de notez que des nom de méthodes non Judicieux ne passera pas à la revue

#### Comment nommez les classes

Le nommage des classes est l'inverse du nommage des variable on commance par Qui et on finis par sa fonction. 

Contexte imaginons qu'on crée un manipulateur de camera.

```gdscript
class_name CameraHandler # Très Bien
class_name HandlerCamera # Pas Bien
```

Imaginon qu'on crée des classe qui hérites les une des autres par example pour le déplacement des personage

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
> Si pour les classes c'est inverser c'est pour qu'on retouve plus facilement les variant de cettes classe (Enfant et Parent) mais aussi car ce ne sont pas des actions mais des definition de.
> 
> Il est donc plus aisée de présentez en premier de qui on parle et de sont rôle après 

## Quand utiliser GDScript et GDExtention
- GDScript est réserver au code simple qu n'éssite pas mal de perfomance. On l'utilisera aussi pour prototiper des éléments qu'on réècrira au moment voulu en GDExtention
-  GDExtention est réserver à la parite performance du code tout ce qui est phisique.

## GDScript
### Avant de commencer
- Lire [GDScript Style](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdscript/index.html) vous dis comment écrire votre code
- Lire [GDScript Réfèrence](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdscript/gdscript_basics.html) vous explique les particulariter du language 
- Lire [GDScript Properties](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdscript/gdscript_exports.html) vous servira pour avoir un afficheage propre dans la vue 3D

> [!WARNING]
> Ne réinventer pas la roux est priviligier les méthodes de GDScript pour les calcul ou autres.
> 
> Il y'a deux raison à ça:
> 
> La première c'est la feignatise il ne faut pas réinventer la roux
> 
> La deuximées c'est la rapiditer GDScript est très lent. Donc même si d'un point de vue algo votre code est meilleur. Il risque d'étres plus performant d'utiliser les méthode de GDScript qui pointe vers du c++
> 
> Si jamais il y'a pas d'autre choix il sera donc plus pertinant d'utiliser [GDExtention](#gdxtention)

### Typage
Dans gdscipt le typage est dynamique c'est sympatique car ça donne beacoup plus de flexibilitez. Là ou c'est mauvais c'est que ça peut réduite la compréhention du code.

C'est pour celà qu'il faut au maximum typer avec son langage. 
Une autre raison de typer le langage c'est la performance car l'ordinateurs vas perdre quelques ms seconde à trouver le bon type

Voici un example de typage de variable
```gdscript
var une_variable: Variant = "coucou" # Typage automatique forcer
var une_variable: = "coucou" # Typage automatique
var un_string_variant: String = "coucou" # Typage dynamique
```

Voici un example de typage en fonction
```gdscript
func addition(a: float, b:float) -> float:
	return (a+b)
```

Imaginon maitenant qu'on veux stocker quelque chose de quelquonque. Ici on pourais ce dire super j'ai pas à typer est pas non il faudra maitre le type `Variant`

```gdscript
var array: Array

func ajout_quelquonque(add: Variant):
	array.push_back(add)
```

## GDExtention
### Avant de commencer
> [!WARNING]
> GDExtention c++ à très peut de documentation

- lire [GDExtention c++](https://docs.godotengine.org/fr/4.x/tutorials/scripting/gdextension/index.html) 

> [!WARNING]
> Comming Soon

## Documentation
### Différences entre commentaire et documentaion

#### Comentaire
> Un commentaire est une expliquation qui vise à expliquer un petit bout du code qui n'est guère aisez de comprendre à vue d'euille. Il s'addresse au collègues ou à votre vous du futur qui aurras besoins d'apportez des modification sur ce même code

#### Documentation
> La documentation s'adresse à ce qui vont utiliser vos méthodes ou classes il est là pour apporter des exemples concret ou des expliquation des éléments mis à dispostion de l'utilisateurs de votre classes.
> 
> La documentation est principalement utile pour un travail d'équipe. Elle évite au gens de regarder votre code pour comprendre comment s'en servir.

#### Pour Conclure
Le commentaire est la pour expliquer des éléments succins pour ce qui crée la classe

La documentation est la pour expliquer le fonctionement de votre classe à ce qui vont l'utiliser

### Bien documenter
Pour bien documenter il faut d'abord créer une phrase d'introduction qui explique de manières sucinte le rôle d'une méthode.

Après si besoint on peut rajouter des détailles sur le fonctionement ou le liens avex X ou Y éléments.

> [!TIP]
> Si malgrés l'explication il reste dificile de comprendre comment utiliser votre classe il est pas mal de mêtres un example concret avec des codeblock
