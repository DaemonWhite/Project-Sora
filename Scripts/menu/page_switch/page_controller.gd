class_name PageController
extends Control

var index_current_page
var pages: Array[Page] = []
@export var view_header: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func auto_detect_page() -> void:
	for child in self.get_children():
		if child is Page:
			if null != self.get_page_by_name(child.name_page):
				self.pages.push_back(child)
			else:
				push_warning("Page ignorer car nom dejà existant")


func get_page_by_name(name_page: String) -> Page:
	for page in self.pages:
		if page.name_page == name_page:
			return page
	
	return null

func add_page(page: Page) -> void:
	self.pages.push_back(page)
	
func remove_page(index: int) -> void:
	self.pages.remove_at(index)
