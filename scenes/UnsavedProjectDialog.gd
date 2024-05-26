extends Window
class_name UnsavedProjectDialog

var target:ProjectEditor
@onready var body = find_child("Body")

func show_for(project_editor:ProjectEditor):
	target = project_editor
	body.text = "Project \"%s\" has unsaved changes!" % project_editor.project.name
	show()


func _on_close_anyway_button_pressed():
	target.queue_free()
	queue_free()


func _on_save_and_close_button_pressed():
	target.save()
	target.queue_free()
	queue_free()


func _on_cancel_button_pressed():
	queue_free()


func _on_close_requested():
	queue_free()
