# Arboressance des scènes
Les scène doivent êtres ranger dans des dossier en fonction de leurs logiques par exemple si on crées une scènes menu elle sera mis dans l'ordre suivant
```sh
/scences/menu/main.tscn # Le menu principale si il y'a  
/scenes/menu/ui/button.tscn # Un bouton génériques
/scenes/menu/modal/inventory.tscn  # L'inventaire dans le jeu
```

L'aboressance est important pour s'y retrouver par exemples si on crée plusieurs bouton il est mieux de créer un dossier bouton ce qui nous donnera cette arborescence

```sh
/scences/menu/main.tscn # Le menu principale si il y'a  
/scenes/menu/ui/button/menu_button.tscn # Bouton menu
/scenes/menu/ui/button/inventory_button.tscn # Bouton d'inventaire
/scenes/menu/modal/inventory.tscn  # L'inventaire dans le jeu
```


# Scenes de teste
comme dans tout jeux on auras des maps qui sert juste à tester les fonctionnalité elle seront alors tous ranger dans le dossier
```sh 
/scenes/teste/ # Le rangement dans teste suivera la même logique
```

# Les erreurs de l’incompétent DaemonWhite
on utilisera de préférence l'anglais pour aider le petit daemonwhite à s’améliorer En cas de faute d’orthographe n’hésitez pas à corriger