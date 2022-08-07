extends Control

onready var startButton = $StartButton

func _on_StartButton_pressed():
	get_tree().change_scene("res://Game/Game.tscn")


func _on_StartButton_button_down():
	startButton.rect_position += Vector2(2,2)


func _on_StartButton_button_up():
	startButton.rect_position -= Vector2(2,2)
