extends TabContainer

var tab_bar:TabBar = get_tab_bar()
var close_button_icon = preload("res://addons/google_material/close_20dp_FILL0_wght400_GRAD0_opsz20.svg")
var UnsavedChangesScene = preload("res://scenes/unsaved_project_dialog.tscn")
func _on_tab_changed(tab_id:int):
	if get_child(tab_id) as ProjectEditor:
		set_tab_button_icon(tab_id,close_button_icon)


func _on_tab_button_pressed(tab_id):
	var project_editor = get_child(tab_id) as ProjectEditor
	if project_editor:
		if project_editor.changes:
			var dialog = UnsavedChangesScene.instantiate()
			add_child(dialog)
			dialog.show_for(project_editor)
		else:
			get_child(tab_id).queue_free()
