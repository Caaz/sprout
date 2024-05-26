extends HSplitContainer
class_name ProjectEditor
var project:Project
var project_meta:ProjectMeta
var changes:bool = false
@onready var document_tree:DocumentTree = find_child("DocumentTree")
@onready var input_body = find_child("MarkdownInput")
@onready var document_preview = find_child("MarkdownOutput")
@onready var sprout = get_parent().find_child("Sprout")

func _ready():
	if project_meta and FileAccess.file_exists(project_meta.location):
		project = Project.load(project_meta.location)
		
	if not project:
		project = Project.new()
		project.document_tree.title = "Untitled Project"
	
	name = project.name
	
	document_tree.set_project(project)
	_set_editor_contents()
	
func _set_editor_contents():
	var document:Document = document_tree.get_document()
	$DocumentContainer.visible = document != null
	if document:
		input_body.text = document.body
		document_preview.markdown_text = document.body
		$DocumentContainer/Editor/VBoxContainer/TitleInput.text = document.title

func _set_title(new_title:String):
	var selected_item = document_tree.get_selected()
	selected_item.get_metadata(0).title = new_title
	selected_item.set_text(0, new_title)
	name = project.name
	changes = true
	
func _set_body():
	var document:Document = document_tree.get_document()
	document.body = input_body.text
	document_preview.markdown_text = input_body.text
	changes = true
	
func _on_add_document_button_pressed():
	var selected_item = document_tree.get_selected()
	if selected_item:
		var new_item:TreeItem = document_tree.add_document(Document.new(), selected_item, true)
		document_tree.set_selected(new_item, 0)
		_set_editor_contents()
		changes = true


func _on_preview_toggle_toggled(toggled_on):
	find_child("Preview").visible = toggled_on


func save():
	project.save(project_meta.location)
	project_meta.name = project.name
	sprout.save()
	changes = false
