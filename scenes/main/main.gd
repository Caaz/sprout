extends Control
var NotificationScene = preload("res://scenes/main/notification.tscn")

func add_notification(text:String):
	var notification = NotificationScene.instantiate()
	notification.set_text(text)
	$MarginContainer/NotificationController.add_child(notification)
