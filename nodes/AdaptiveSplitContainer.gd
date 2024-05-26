extends SplitContainer
class_name AdaptiveSplitContainer

var offset_percentage:float = .5

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().size_changed.connect(reset_split)
	dragged.connect(_on_dragged)

func reset_split():
	split_offset = size.x * offset_percentage

func _on_dragged(offset):
	offset_percentage = offset / size.x 
