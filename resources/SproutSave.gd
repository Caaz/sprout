extends Resource
class_name SproutSave

@export var project_locations:Array[String]

signal saved(error:Error)

static func load(location:String) -> SproutSave:
	var temp_save:SproutSave = ResourceLoader.load(location, "SproutSave")
	if temp_save:
		# TODO: Notify user old save was loaded.
		return temp_save
	else:
		# TODO: Notify user new save has been created
		return SproutSave.new()
		
func save() -> Error:
	var error:Error = ResourceSaver.save(self, resource_path)
	print("Saved, emitting signal")
	saved.emit(error)
	return error

func add_project(path:String, post_save:bool = true):
	for location in project_locations:
		if location == path:
			return
	
	project_locations.append(path)
	if post_save:
		save()

func remove_projects(locations:Array[String], post_save:bool = true):
	project_locations = project_locations.filter(func (location):
		return not locations.has(location)
	)
	if post_save:
		save()
	
