extends MarginContainer

var save_data:SproutSave

const SAVE_LOCATION = "user://sprout.tres"
const ProjectScene = preload("res://scenes/project.tscn")

@onready var project_list:ItemList = find_child("ProjectList")
@onready var new_project_button:Button = find_child("NewProjectButton")
@onready var main:TabContainer = get_parent()

func _ready():
	#ResourceSaver.add_resource_format_saver(SproutSaveSaver.new())
	_load()
	#project_list.item_activated.connect(_on_item_activated)
	new_project_button.pressed.connect(_on_new_project_pressed)
	_update_project_list()

func _load():
	var temp_save = ResourceLoader.load(SAVE_LOCATION, "SproutSave")
	if temp_save:
		save_data = temp_save
	else:
		print("No save, creating a new one")
		save_data = SproutSave.new()

func save():
	ResourceSaver.save(save_data, SAVE_LOCATION)
	_update_project_list()

func _update_project_list():
	project_list.clear()
	if save:
		for project in save_data.projects:
			project_list.add_item(project.location)

func _open_project(project_meta:ProjectMeta):
	for child in main.get_children():
		var project_editor = child as ProjectEditor
		if project_editor and project_editor.project_meta.location == project_meta.location:
			main.current_tab = project_editor.get_index()
			return
	var project_scene = ProjectScene.instantiate()
	project_scene.project_meta = project_meta
	
	get_parent().add_child(project_scene)
	main.current_tab = main.get_tab_count()-1
	
func _on_item_activated(index):
	var project_meta:ProjectMeta = save_data.projects[index]
	_open_project(project_meta)
	
func _on_new_project_pressed():
	$NewProjectDialog.show()

func _on_import_project_button_pressed():
	$ImportProjectDialog.show()

func _on_new_project_dialog_file_selected(path):
	var project_meta = ProjectMeta.new()
	project_meta.name = "Untitled Project"
	project_meta.location = path
	save_data.projects.append(project_meta)
	_open_project(project_meta)

func _on_import_project_dialog_file_selected(path):
	var project_meta = ProjectMeta.new()
	project_meta.location = path
	_open_project(project_meta)
	for project in save_data.projects:
		if project.location == project_meta.location:
			return
	save_data.projects.append(project_meta)
	save()
	
func _on_delete_project_button_pressed():
	var selected_items = project_list.get_selected_items()
	selected_items.sort()
	selected_items.reverse()
	for item:int in selected_items:
		save_data.projects.remove_at(item)
	save()



