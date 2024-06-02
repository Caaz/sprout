extends Resource
class_name Kanban

var columns:Array[Column]

static func from_dict(dict):
	var kanban = Kanban.new()
	if not dict:
		return kanban
	for column_dict in dict["columns"]:
		print("Loading ",column_dict)
		var column:Column = Column.from_dict(column_dict)
		kanban.columns.append(column)
	return kanban

func to_dict() -> Dictionary:
	var dict:Dictionary = {
		"columns": []
	}
	for column:Column in columns:
		dict["columns"].append(column.to_dict())
		
	return dict


class Task:
	var body:String
	
	static func from_dict(dict:Dictionary) -> Task:
		var task = Task.new()
		task.body = dict["body"]
		return task
		
	func to_dict() -> Dictionary:
		return { "body": body }


class Column:
	var name:String
	var tasks:Array[Task]
	
	static func from_dict(dict:Dictionary) -> Column:
		var column = Column.new()
		column.name = dict["name"]
		for task_dict in dict["tasks"]:
			var task = Task.from_dict(task_dict)
			column.tasks.append(task)
		return column
		
	func to_dict() -> Dictionary:
		var dict = {
			"name": name,
			"tasks": [],
		}
		for task in tasks:
			dict["tasks"].append(task.to_dict())
		return dict
