extends Control

onready var scoreLabel = $ScoreLabel
onready var bestScoreLabel = $BestScoreLabel
onready var restartButton = $RestartButton


func _ready():
	scoreLabel.text = "Your score: " + str(ProgressTracking.score)
	bestScoreLabel.text = "Best score: " + str(ProgressTracking.best_score)


func _on_RestartButton_pressed():
	ProgressTracking.reset()
	get_tree().change_scene("res://Game/Game.tscn")


func _on_RestartButton_button_down():
	restartButton.rect_position += Vector2(2,2)


func _on_RestartButton_button_up():
	restartButton.rect_position -= Vector2(2,2)
