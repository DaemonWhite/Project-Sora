# Contribution
Bienvenue au saint projet sora ici on vas voir les différentes règles de contribution

> [!WARNING]
> Avant toute choses il faut que vous lisiez la         [conduite du code](CODE_OF_CONDUCT.md) si vous voullez contribuer au code autrement pour les assets allez voir [l'architecture du projet](README.md).

## Sommaire
- [Ajouter une nouvelle fonctionaliter](Travailler_sur_une_nouvelle_fonctionnalité_au_projet)
- [Les commits](#Les_commits)
- [Les pull requests](lLes_pull_request)

## Travailler sur une nouvelle fonctionnalité au projet
- Créer une nouvelle branche avec le nom de la fonctionnalité [example : Camera]
- Chaque ajout de fonctionnalité au code devront êtres commit (avec nom approprier [example : "Camera : ajout Switch première seconde personne"]) et DOCUMENTER

## Les Commits
Pour les commits il faut respecter une syntaxe particulière pour ça créons un contexte.

### Contexte

Imaginons que l'on crée la possibilité de passer d'une caméra première personne à une camera troisième personne.

### Syntaxe de base
Imaginons que l'on apporte une fonctionnalité
`Add: Switch Camera -> Permet de permuter entre première et troisiémes camera`

Imaginons que l'on apporte des changements à notre switch camera

`Change: Switch Caméra fonctionne avec signaux mtn`

Imaginons que l'on corrige un bug mtn

`Fix: Switch Camera -> Le switch étais inversé`

> [!TIP]
> On remarque la syntaxe du commit suit toujours cette logique
> [Type]: [Truc influencer] [Description]

> [!NOTE]
> Pas besoin d'écrire en anglais Add Change et Fix
> 
> Le franglais est autorisée


### Syntaxe Avancer
Imaginons qu'on ajoute plein de fonctionnalité mineur ou répétitive. Dans le cas d'un menu par exemple on vas pas s’amuser à faire un commit par bouton. 

Dans ce cas la on vas les regrouper

` Add: Boutons menu contrôle (Déplacement, Contrôle Caméra, etc)`

> [!WARNING]
> A noter qu'il faut quand même qu'ils ont un liens entre eux. Par example on ne met pas pas dans le même commit les boutons des contrôles avec celui des items.

## Les pull request
Les pull request sont les demandes de raliement d'une branche à une autre (en générale le main). Pour les pull request il faudra suivre les règles suivantes :

### Description
La description dois contenir une liste de teste à exécuter Ainsi qu'un rappelle de la branche par exemple :

> [!IMPORTANT]
> # CameraHandler
> #1 (Lien vers issue)
> 
> ## Description
> Camera Handler permet de manipuler la camera première et troisième personne
> Elle peut ce lier à un CharacterBody3D
> 
> # teste
> 
> ## Information
> - On peut changer de personage avec les 1,2,3,4,5
> - Déplacement flèches clavier + espace pour sauter
> - "," et "L" bloque respectivement le mouvement et la caméra
> - "P" Passe en free mode
> - Le personnage 5 A un comportement complexe à un script par défaut, ne génère pas d'avertisement
> - Les personnages 1,2,3,4 on un comportement simple ils suivent la camera comme des idiots. La caméra leur attache un script dynamiquement ce qui génère une erreur.
> 
> ## Element à teste
> - [ ] Déplacement
>     - [ ] Déplacement Simple de 1,2,3,4
>     - [ ] Déplacement Complexe 5
>  -[ ] Changement de Camera
> - [ ] Une fois 5 sélectioné il dois toujours ce déplacer même si plus il n'est plus sélectioné
> 
> ## Fichier de testes
> 
> Scenes/test/camera.tscn
> 
> Script/test/camera/camera.gd

### Avant de valider la pull request
- Relecture du code pour enlever les incohérances ou gérer les oublies
- Relecture de la DOC
- Au moins une personne à validé

### Valider la pull request
Pour le pull request à prendre il faudra choisir rebase 
