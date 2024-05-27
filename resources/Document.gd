extends Resource
class_name Document

@export var title:String = "Untitled Document":
	get:
		return title
	set(new_title):
		title = new_title
		emit_changed()

@export var body:String = "":
	get:
		return body
	set(new_body):
		body = new_body
		emit_changed()

@export var children:Array[Document] = []

var _initial_title:String
var _initial_body:String

func has_changes():
	return _initial_title != title or _initial_body != body

func set_initial_values():
	_initial_title = title
	_initial_body = body
	
func to_dict():
	var children_array = []
	for child in children:
		children_array.append(child.to_dict())
	
	return {
		"title": title,
		"body": body,
		"children": children_array
	}

static func from_dict(dict:Dictionary):
	var document = Document.new()
	document.title = dict["title"]
	document.body = dict["body"]
	document.set_initial_values()
	
	for child in dict["children"]:
		document.children.append(Document.from_dict(child))
	return document
