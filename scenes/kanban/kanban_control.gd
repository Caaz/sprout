extends MarginContainer

var resource:Kanban
@onready var board = find_child("Board")
var KanbanColumnScene = preload("res://scenes/kanban/kanban_column.tscn")

func from_resource(kanban_resource:Kanban):
	resource = kanban_resource
	
	for child in board.get_children():
		child.queue_free()
		
	for column in kanban_resource.columns:
		print("loaded column: ",column.name)
		var kanban_column:KanbanColumn = KanbanColumnScene.instantiate()
		kanban_column.from_resource(column)
		board.add_child(kanban_column)

func to_resource() -> Kanban:
	resource.columns = []
	for child:KanbanColumn in board.get_children():
		resource.columns.append(child.to_resource())
	return resource


func _on_add_column_button_pressed():
	board.add_child(KanbanColumnScene.instantiate())
