# CameraHandler
#1 (Lien vers issue)
 
## Description
Camera Handler permet de manipuler la camera première et troisième personne
Elle peut ce lier à un CharacterBody3D
 
# teste
 
## Information
- On peut changer de personage avec les 1,2,3,4,5
- Déplacement flèches clavier + espace pour sauter
- "," et "L" bloque respectivement le mouvement et la caméra
- "P" Passe en free mode
- Le personnage 5 A un comportement complexe à un script par défaut, ne génère pas d'avertisement
- Les personnages 1,2,3,4 on un comportement simple ils suivent la camera comme des idiots. La caméra leur attache un script dynamiquement ce qui génère une erreur.

## Element à teste
- [ ] Déplacement
    - [ ] Déplacement Simple de 1,2,3,4
    - [ ] Déplacement Complexe 5
 -[ ] Changement de Camera
- [ ] Une fois 5 sélectioné il dois toujours ce déplacer même si plus il n'est plus sélectioné

## Fichier de testes

Scenes/test/camera.tscn

Script/test/camera/camera.gd