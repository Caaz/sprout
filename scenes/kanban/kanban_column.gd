extends PanelContainer
class_name KanbanColumn

var TaskControl = preload("res://scenes/kanban/task_control.tscn")
@onready var header:LineEdit = find_child("Name")
@onready var task_container = find_child("TaskContainer")
var resource:Kanban.Column = Kanban.Column.new()

func _on_add_task_button_pressed():
	var task = TaskControl.instantiate()
	task_container.add_child(task)

func from_resource(column_resource:Kanban.Column):
	resource = column_resource
	find_child("Name").text = column_resource.name
	for task_resource in column_resource.tasks:
		var task = TaskControl.instantiate()
		task.from_resource(task_resource)
		find_child("TaskContainer").add_child(task)

func to_resource() -> Kanban.Column:
	resource.tasks = []
	resource.name = header.text
	for child:TaskControl in task_container.get_children():
		resource.tasks.append(child.to_resource())
	return resource
