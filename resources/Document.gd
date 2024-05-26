extends Resource
class_name Document

@export var title:String = "Untitled Document":
	get:
		return title
	set(new_title):
		if title != new_title:
			unsaved_changes = true
		title = new_title

@export var body:String = "":
	get:
		return body
	set(new_body):
		if body != new_body:
			unsaved_changes = true
		body = new_body

@export var children:Array[Document] = []

var unsaved_changes = false

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
	for child in dict["children"]:
		document.children.append(Document.from_dict(child))
	document.unsaved_changes = false
	return document
