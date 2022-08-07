extends Control

onready var label = $ArticleButton/ArticleLabel

var label_text = ""


func set_label_text(label_text_to_set):
	label_text = label_text_to_set

	# Shrink longer article titles
	if label_text.length() > 35:
		var font_override = DynamicFont.new()
		font_override.font_data = load("res://Fonts/Montserrat-VariableFont_wght.ttf")
		font_override.size = 13
		label.add_font_override("font", font_override)

	label.bbcode_text = "[center]" + label_text + "[/center]"


func _on_ArticleButton_button_down():
	rect_position += Vector2(2,2)


func _on_ArticleButton_button_up():
	rect_position -= Vector2(2,2)


func _on_ArticleButton_pressed():
	Events.emit_signal("button_pressed", label_text)
