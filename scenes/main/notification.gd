extends PanelContainer
class_name Notification

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(2.0).timeout
	_on_close_button_pressed()

func set_text(text:String):
	$MarginContainer/HBoxContainer/Label.text = text

func _on_close_button_pressed():
	$AnimationPlayer.play("fade_in", -1, -1.0, true)
	$AnimationPlayer.animation_finished.connect(func(_animation_name):
		queue_free()
	)
