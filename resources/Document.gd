extends Resource
class_name Document

@export var title:String = "Untitled Document"
@export var body:String = ""
@export var children:Array[Document] = []


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
	return document
