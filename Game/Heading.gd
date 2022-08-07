extends Control

onready var label = $Label


func set_heading_text(string):
	label.text = string

func set_label_color(color):
	label.add_color_override("font_color", color)
