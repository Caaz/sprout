extends PanelContainer
class_name TaskControl

var resource:Kanban.Task = Kanban.Task.new()

@onready var body:TextEdit = find_child("Body")

func from_resource(task_resource:Kanban.Task):
	resource = task_resource
	find_child("Body").text = resource.body
	
func to_resource() -> Kanban.Task:
	return resource


func _on_body_text_changed():
	resource.body = body.text
