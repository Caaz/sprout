extends SplitContainer
class_name DocumentEditor

var active_document:Document
@onready var body_input = find_child("MarkdownInput")
@onready var title_input = find_child("TitleInput")
@onready var preview:MarkdownLabel = find_child("MarkdownOutput")

func _ready():
	var _offset_percentage:float = .5
	get_viewport().size_changed.connect(func ():
		split_offset = size.x * _offset_percentage
	)
	dragged.connect(func (offset):
		_offset_percentage = offset / size.x
	)

func set_document(document:Document):
	active_document = document
	visible = document != null
	if document:
		title_input.text = document.title
		body_input.text = document.body

func _on_body_input_changed():
	if active_document:
		active_document.body = body_input.text
		_update_preview()

func _on_title_input_changed(new_text):
	if active_document:
		active_document.title = title_input.text
		_update_preview()

func _update_preview():
	preview.markdown_text = "#%s\n%s" % [title_input.text, body_input.text]
