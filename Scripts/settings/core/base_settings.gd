class_name  BaseSettings
extends Object
## Gère la sauvegarde des parmaètrs et sert de classe de base pour les paramètres
##
## La classe permet de gérer les sauvegardes des paramètres à partir de méthodes static.
## Les méthodes non static sont prévues pour être virtuel. Et doit être donc utilisé par 
## la classe Enfant. La classe BaseSettings n'est donc pas à utiliser pour créer 
## un nouveau paramètre, mais pour créer une classe enfant qui elle s'occupera des paramètres. 
## [br][br]
## [color=Orange][b] ATTENTION [/b][/color][br]
## On utilisera le terme configuration courrante pour la classe [ConfigFile]
## On utilisera le terme paramètre courrant pour les membres de la classe [BaseSettings]
## [br][br]
## Vous pouver creer vos propres règles de paramètres comme ceci. Example pris de [SingleOptionSettings]
## [codeblock]
## 	class_name  SingleOptionSettings
## 	extends BaseSettings
##
##  # Définis la liste des options possibles
##	var _options: Array
##
##  # Permet de récupérer la dites liste
##	func get_options() -> Array:
##	    return _options
##	
##  # Redéfinis la méthode pour choisir l'option
##  # En rajoutant la gestion d'erreur
##	func set_current_option(value: Variant):
##	    if self.exist_option(value):
##		    self._current_option = value
##		else:
##		    push_warning("Options non existante", self)
##	
##  # Offre une nouvelle méthode pour vérifier la bonne existence de l'option.
##	func exist_option(search: String):
##	    for option in self._options:
##		    if option[0] == search:
##			    return true
##				
##	    return false
##	
## [/codeblock]
## [br]
## Maintenant, qu'ont à créer des règles de paramètre, 
## il faut qu'on puisse ajouter nos paramètres. 
## [codeblock]
## class_name ResolutionSetting
## extends SingleOptionSettings
## 
##	func _ready():
##      # Le nom est obligatoire défini par [BaseSettings]
##	    self._name = "RESOLUTION"
##      # Le group est obligatoir défini par [BaseSettings]
##	    self._group = BaseSettings.GROUP.GRAPHICS
##      # L'option est obligatoire défini par [SingleOptionSettings]
##	    self._options = [ 
##	        ["2560x1440", Vector2i(2560,1440)],
##	        ["1920x1080", Vector2i(1920,1080)],
##	        ["1366x768", Vector2i(1366,768)],
##	        ["1536x864", Vector2i(1536,864)],
##	        ["1280x720", Vector2i(1280,720)],
##	        ["1440x900", Vector2i(1440,900)],
##	        ["1600x900", Vector2i(1600,900)],
##	        ["1024x600", Vector2i(1024,600)],
##	        ["800x600", Vector2i(800,600)]
##	    ]
## 
## 	    # L'option par défaut est obligatoire défini par [BaseSettings]
## 	    self._default_option = "800x600"
## [/codeblock]
## [br]
## Au démarrage du système, on a plus qu'a instancier la classe [code]ResolutionSetting.new()[/code].
## Elle sera alors automatiquement ajoutée dans [member BaseSettings._list_settings] 
## donc pas besoin de la stocker dans une variable sauf si vous voulez apporter 
## des modifications après.
## [br][br]
## Dans le cas où vous voudriez le récupérer dans un autre script, il vous suffit de vous référer
## à [method BaseSettings.get_settings_by_name]

## Norm du paramètre
var _name: String = ""

## Group du paramètre voir [enum BaseSettings.GROUP]
var _group: BaseSettings.GROUP = BaseSettings.GROUP.OTHER

## Paramètre par défaut
var _default_option: Variant = null

## Paramètre courant
var _current_option: Variant = null

## Liste toutes les classes enfant instanciées.
static var _list_settings: Array = []
## Contient la configuration courante
static var _config: ConfigFile = ConfigFile.new()
## Contient le chemin de la configuration sauvegarder
static var _path_settings: String = ""

## Signal envoyer quand la méthode [method BaseSettings.apply] est appeler
signal apply_signal(Class, save)

## Liste les différentes catégories prise en charge 
enum GROUP {
	## Catégorire des Divers
	OTHER,
	## Catégorie en lien avec les graphismes
	GRAPHICS,
	## Catégorie en lien avec le son
	SOUND,
	## Catégorie en lien avec les controlles
	KEYBOARD
}

func _init() -> void:
	BaseSettings._list_settings.append(self)
	self._ready()
	
	var current_option = BaseSettings._config.get_value(
		self.get_group_to_string(self._group), 
		self._name
	)
	
	if current_option != null:
		self.set_current_option(current_option)
		self.apply(false)
	else:
		self.reset()
		
	# TODO: Ajouter une meilleur vérification d'erreur
	if self._name == null:
		push_warning("Nom non définie de ", self)
	
	if self._default_option == null:
		push_warning("Aucune option par défaut", self)


## À utiliser pour configurer les paramètres de l'enfant
func _ready() -> void:
	pass # Replace with function body.

## Methode virtuelle appeler quand [method BaseSettings.apply] est appeler
func _apply() -> void:
	pass

## Applique le paramètre à la configuration par défaut et sauvegarde directement 
## dans le fichier Passer false si la sauvegarde instantanée et non désirer
func apply(save: bool=true) -> void:
	BaseSettings._config.set_value(
		BaseSettings.get_group_to_string(self._group),
		self._name,
		self._current_option
	)
	self.apply_signal.emit(self, save)
	self._apply()
	if save:
		BaseSettings.save()

## Réinitialises-en appliquant le paramètre automatiquement.[br]
## [color=Orange][b] ATTENTION [/b][/color] Ne sauvegarde pas la configuration voir 
## [method BaseSettings.save] pour sauvegarder.
func reset():
	self._current_option = self._default_option
	self.apply(false)

## Renvoie le paramètre courant.
func get_current_option() -> Variant:
	return self._current_option

## Renvoie le paramètre par défaut
func get_default_option() -> Variant:
	return self._default_option

## Renvoie la catégorie du paramètre
func get_group() -> BaseSettings.GROUP:
	return self._group

## Convertie le groupe [enum BaseSettings.GROUP] en chaine de charactères
static func get_group_to_string(group_enum: BaseSettings.GROUP) -> String:
	var categorie: String = ""
	match group_enum:
		BaseSettings.GROUP.OTHER:
			categorie = "OTHER"
		BaseSettings.GROUP.GRAPHICS:
			categorie = "GRAPHICS"
		BaseSettings.GROUP.SOUND: 
			categorie = "SOUND"
		BaseSettings.GROUP.KEYBOARD:
			categorie = "KEYBOARD"
			
	return categorie

## Renvoie le non du paramètre
func get_name() -> String:
	return self._name

## Renvoie le chemin de sauvegarde de la configuration
static func get_path_settings() -> String:
	return BaseSettings._path_settings

## Renvoie tout les paramètres instancier
static func get_settings() -> Array:
	return BaseSettings._list_settings

## Renvoie tous les paramètres instanciés appartenant à la catégorie désignée voir [enum BaseSettings.GROUP]
static func get_settings_by_enum(group_enum: BaseSettings) -> Array:
	var list_settings: Array

	for setting in BaseSettings._list_settings:
		if setting.get_group() == group_enum:
			list_settings.append(setting)

	return list_settings

## Revois le paramètre instancier en passant son groupe et son Nom.
static func get_settings_by_name(group_enum: BaseSettings.GROUP , name: String) -> Variant:
	for setting in BaseSettings._list_settings:
		if setting.get_group() == group_enum and setting.get_name() == name:
			return setting
	
	return null

## Vérifie si la configuration courante et différente du paramètre courant
func is_different() -> bool:
	return BaseSettings._config.get_value(
		BaseSettings.get_group_to_string(self._group), 
		self._name
	) != self._current_option
	
## Vérifie si le paramètre diffère de celui par défaut.
func is_not_default() -> bool:
	return BaseSettings._config.get_value(
		BaseSettings.get_group_to_string(self._group), 
		self._name
	) != self._default_option

## Change le paramètre courant.
func set_current_option(option: Variant):
	self._current_option = option

## Change le chemin de sauvegarde.
static func set_path_settings(path: String):
	BaseSettings._path_settings = path

## Charge la configuration sauvegarde dans la configuration courante.
static func load() -> Error:
	return BaseSettings._config.load(BaseSettings._path_settings)

## Sauvegarde la configuration courante dans un fichier.
static func save() -> Error:
	return BaseSettings._config.save(BaseSettings._path_settings)
