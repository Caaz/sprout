extends SplitContainer
class_name DocumentEditor

signal document_changed(document)
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
	if active_document:
		active_document.changed.disconnect(_on_document_changed)
	active_document = document
	active_document.changed.connect(_on_document_changed)
	visible = document != null
	if document:
		title_input.text = document.title
		body_input.text = document.body

func _on_body_input_changed():
	if active_document:
		active_document.body = body_input.text

func _on_title_input_changed(new_text):
	if active_document:
		active_document.title = new_text

func _on_document_changed():
	preview.markdown_text = "#%s\n%s" % [active_document.title, active_document.body]
	document_changed.emit(active_document)
