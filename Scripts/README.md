# Arboressance des Scripts
Les scripts doivent êtres ranger dans des dossier en fonction de leurs logiques par exemple si on crée un script camer elle sera mis dans l'ordre suivant

## La base 

```sh
/scripts/camera/camera.gd # Le script principale de la caméra
/scritps/camera/character_camera.gd # Le script qui contrôle la caméra
```

Il pourras avoir des sous dossier par exemple imaginons qu'on crée des scripts pour l'inventaires.

## Avancer

```sh
/scripts/inventory/inventory.gd # Le script principale de la caméra
/scritps/inventory/item.gd # Le script qui contrôle la caméra
/scritps/inventory/sort/by_name.gd  # Trie les items par nom
/scritps/inventory/sort/by_quantity.gd  # Trie les items par quantitée 
```

## Autre cas
```sh
/scripts/utils/ # ici on mettra tout les script générique qui peuvent êtres utiliser par tout.
```


# Les erreurs de l’incompétent DaemonWhite
on utilisera de préférence l'anglais pour aider le petit daemonwhite à s’améliorer En cas de faute d’orthographe n’hésitez pas à corriger