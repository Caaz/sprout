extends MarginContainer


const ProjectScene = preload("res://scenes/project_editor/project_editor.tscn")

@onready var sprout_save:SproutSave
@onready var project_list:ItemList = find_child("ProjectList")
@onready var main:TabContainer = get_parent()

func _ready():
	sprout_save = SproutSave.load("user://sprout.tres")
	sprout_save.saved.connect(func (error:Error):
		_update_project_list()
	)
	_update_project_list()

	
func save():
	sprout_save.save()

func _update_project_list():
	project_list.clear()
	if save:
		for location in sprout_save.project_locations:
			project_list.add_item(location)

func _open_project(project_location:String):
	for child in main.get_children():
		var project_editor = child as ProjectEditor
		if project_editor and project_editor.project_location == project_location:
			main.current_tab = project_editor.get_index()
			return
	
	var project_scene = ProjectScene.instantiate()
	project_scene.project_location = project_location
	
	get_parent().add_child(project_scene)
	main.current_tab = main.get_tab_count()-1
	
func _on_item_activated(index):
	_open_project(project_list.get_item_text(index))
	
func _on_new_project_button_pressed():
	$NewProjectDialog.show()

func _on_import_project_button_pressed():
	$ImportProjectDialog.show()

func _on_dialog_file_selected(path:String) -> void:
	sprout_save.add_project(path)
	_open_project(path)

func _on_delete_project_button_pressed() -> void:
	var selected_items = project_list.get_selected_items()
	var selected_locations:Array[String] = []
	
	for item:int in selected_items:
		selected_locations.append(sprout_save.project_locations[item])
		
	sprout_save.remove_projects(selected_locations)
