extends HSplitContainer
class_name ProjectEditor
var project:Project
var project_location:String

@onready var document_tree:DocumentTree = find_child("DocumentTree")
@onready var input_body = find_child("MarkdownInput")
@onready var document_preview = find_child("MarkdownOutput")
@onready var sprout = get_parent().find_child("Sprout")
@onready var document_editor = find_child("DocumentEditor")

func _ready():
	if project_location and FileAccess.file_exists(project_location):
		project = Project.load(project_location)
		
	if not project:
		project = Project.new()
		project.document_tree.title = "Untitled Project"
	
	name = project.name
	
	document_tree.set_root(project.document_tree)
	_set_editor_contents()
	
func _set_editor_contents():
	var kanban_toggle:Button = find_child("KanbanToggle")
	kanban_toggle.button_pressed = false
	document_editor.set_document(document_tree.get_document())

func _on_add_document_button_pressed():
	var selected_item = document_tree.get_selected()
	if selected_item:
		var new_item:TreeItem = document_tree.add_document(Document.new(), selected_item, true)
		document_tree.set_selected(new_item, 0)
		_set_editor_contents()

func _on_preview_toggle_toggled(toggled_on):
	find_child("Preview").visible = toggled_on

func _on_kanban_toggle_toggled(toggled_on):
	find_child("Kanban").visible = toggled_on
	document_editor.visible = !toggled_on
	
func save():
	project.save(project_location)
	sprout.save()
	document_tree.clear_changes()
	find_parent("Main").add_notification("Saved!")


func _on_document_tree_root_changed(document):
	name = document.title


