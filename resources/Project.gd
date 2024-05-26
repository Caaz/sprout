extends Resource
class_name Project

@export var name:String:
	get:
		return document_tree.title
			
@export var document_tree:Document = Document.new()

func to_dict():
	return {
		"name": name,
		"document_tree": document_tree.to_dict()
	}

func save(path:String):
	var stringify = JSON.stringify(to_dict())
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(stringify)
	print(path)
	print("saving ",stringify)

static func from_dict(dict:Dictionary):
	var project = Project.new()
	project.document_tree = Document.from_dict(dict["document_tree"])
	return project

static func load(path:String) -> Project:
	var file = FileAccess.open(path, FileAccess.READ)
	var dict = JSON.parse_string(file.get_as_text())
	if dict: 
		return Project.from_dict(dict)
	return null
