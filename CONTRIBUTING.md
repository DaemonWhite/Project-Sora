# Contributing
Bienvenue au saint projet sora ici on vas voir les différentes règles de contribution

> [!WARNING]
> Avant toute choses il faut que vous lisiez la         [conduite du code](CODE_OF_CONDUCT.md) si vous voullez contribuer au code ou à [l'architecture du projet](README.md).

## Sommaire
- [Ajouter une nouvelle fonctionaliter](Travailler_sur_une_nouvelle_fonctionnalité_au_projet)
- [Les commits](#Les_commits)
- [Les pull requests](lLes_pull_request)

## Travailler sur une nouvelle fonctionnalité au projet
- Créer une nouvelle branche avec le nom de la fonctionnalité [example : Camera]
- Chaque ajout de fonctionnalité au code Devront êtres commit (avec nom approprier [example : "Camera : ajout Switch première seconde personne"]) et DOCUMENTER

## Les Commits
Pour les commits il faut respecter une syntaxe particulières pour ça créons un contexte.

### Contexte

Imaginons qu'ont crée la possibilité de passer d'une caméra première personne à une camera troisième personne. le nom du commit sera celui-ci

### Syntaxe de base
> Add: Switch Camera

Imaginons qu'on apporte des changement à notre switch camera

> Change: Switch Camera fonctionne avec signaux mtn

Imaginon qu'ont corrige un bug mtn

> Fix: Switch Camera Le switch étais inverser

On remarque la syntaxe du commit suit toujours cette logique

> [!TIP]
> [Type]: [Truc influencer] [Description]

> [!NOTE]
> Pas besoin d'écrire en anglais Add Change et Fix
> 
> Le franglais est autorisée


### Syntaxe Avancer
Imaginons qu'on ajoute plein de fonctionnaliser mineur ou répétitive. Dans le cas d'un menu par exemple on vas pas s’amuser à faire un commit par bouton. 

Dans ce cas la on vas les regrouper
> Add: Boutons menu controle (Déplacement, Controlle Cameran, etc)

> [!WARNING]
> A noter qu'il faut quand même qu'ils ont un liens entre heux. Par example on ne met pas pas dans le même commit les bouton des controle avec celuis des items.

## Les pull request
Les pull request sont les demandes de raliement d'une branche à une autre (en générale le main). Pour les pull request il faudra suivre les règles suivante

### Description
La description dois contenir une liste de teste à executer. Ainsie qu'un rappelle de la branche par example

> # CameraHandler
> #1 (Liens vers issue)
> 
> ## Description
> Camera Handler permet de manipuler la camera premières et troisièmes personnes
> Elle peut ce lier à un CharacterBody3D
> 
> # teste
> 
> ## Information
> - On peut change de personage avec les 1,2,3,4,5
> - Déplacement flèches clavier + espace pour sauter
> - "," et "L" bloque respectivement le mouvement et la camera
> - "P" Passe en free mode
> - Le personnage 5 A un comportement complexe à un script par défaut ne génère pas d'avertisement
> - Les personnages 1,2,3,4 on un comportement simple il suive la camera comme des idiot. La camera leurs attaches un script dynamiquement ce qui génères une erreurs.
> 
> ## Element à teste
> - [ ] Déplacement
>     - [ ] Déplacement Simple de 1,2,3,4
>     - [ ] Déplacement Complexe 5
>  -[ ] Changement de Camera
> - [ ] Une fois 5 sélectioner il dois toujours ce déplacer même si plus selectioner
> 
> ## Fichier de testes
> 
> Scenes/test/camera.tscn
> 
> Script/test/camera/camera.gd

### Avant de valider la pull request
- Relecture du code pour enlever les incohérance ou gérer les oublier
- Relecture de la DOC
- Au moins une personne à valider

### Valider la pull request
Pour le pull request à prendre il faudra choisir rebase 
