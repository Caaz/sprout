extends Resource
class_name Project

signal saved

@export var name:String:
	get:
		return document_tree.title
	set(new_name):
		document_tree.title = new_name

@export var document_tree:Document = Document.new()
@export var kanban:Kanban = Kanban.new()

func has_unsaved_changes(document:Document = document_tree)-> bool:
	if document.has_changes():
		return true
	for child in document.children:
		if has_unsaved_changes(child):
			return true
	return false
	
func clear_unsaved_changes(document:Document):
	document.set_initial_values()
	for child in document.children:
		clear_unsaved_changes(child)

func to_dict():
	return {
		"name": name,
		"document_tree": document_tree.to_dict(),
		"kanban": kanban.to_dict(),
	}

func save(path:String):
	var stringify = JSON.stringify(to_dict())
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(stringify)
	clear_unsaved_changes(document_tree)
	saved.emit()

static func from_dict(dict:Dictionary):
	var project = Project.new()
	project.document_tree = Document.from_dict(dict["document_tree"])
	project.kanban = Kanban.from_dict(dict.get("kanban"))
	return project

static func load(path:String) -> Project:
	var file = FileAccess.open(path, FileAccess.READ)
	var dict = JSON.parse_string(file.get_as_text())
	if dict: 
		return Project.from_dict(dict)
	return null
