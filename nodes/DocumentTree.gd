extends Tree
class_name DocumentTree

var _dragging_item:TreeItem
@onready var project_editor = find_parent("ProjectEditor")
func _get_drag_data(at_position: Vector2) -> Variant:
	var item = get_item_at_position(at_position)
	if item:
		drop_mode_flags = DROP_MODE_INBETWEEN + DROP_MODE_ON_ITEM
		
		var label:Label = Label.new()
		label.text = item.get_text(0)
		set_drag_preview(label)
		
		_dragging_item = item
		return item
	return null

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var drop_section = get_drop_section_at_position(at_position)
	var drop_item = get_item_at_position(at_position)
	
	if drop_section == -100:
		return false
	if drop_section == 1 and drop_item == data:
		return false
	if _item_has_child(_dragging_item, drop_item):
		return false
		
	return true

func _item_has_child(item:TreeItem, target:TreeItem):
	for child in item.get_children():
		if child == target:
			return true
		elif _item_has_child(child, target):
			return true
	return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var drop_section = get_drop_section_at_position(at_position)
	var item:TreeItem = get_item_at_position(at_position)
	match(drop_section):
		-1:
			_dragging_item.move_before(item)
		0:
			var parent = _dragging_item.get_parent()
			if parent:
				parent.remove_child(_dragging_item)
			item.add_child(_dragging_item)
		1:
			_dragging_item.move_after(item)
	_update_document_heirarchy(get_root())

func _update_document_heirarchy(item:TreeItem):
	var document:Document = item.get_metadata(0)
	document.children = []
	for child in item.get_children():
		document.children.append(child.get_metadata(0))
		_update_document_heirarchy(child)
	project_editor.changes = true


func set_project(project:Project):
	clear()
	add_document(project.document_tree)
		
	set_selected(get_root(), 0)


func add_document(document:Document, parent:TreeItem=null, reparent:bool=false) -> TreeItem:
	var new_item:TreeItem = create_item(parent)
	new_item.set_text(0, document.title)
	new_item.set_metadata(0, document)
	
	
	for child in document.children:
		add_document(child, new_item)
		
	if reparent and parent:
		var parent_document:Document = parent.get_metadata(0)
		parent_document.children.append(document)
		
	return new_item

func get_document() -> Document:
	var item = get_selected()
	if item:
		return item.get_metadata(0)
	return null