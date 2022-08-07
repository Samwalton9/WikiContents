extends Control

onready var scoreLabel = $ScoreLabel
onready var bestScoreLabel = $BestScoreLabel


func _ready():
	scoreLabel.text = "Your score: " + str(ProgressTracking.score)
	bestScoreLabel.text = "Best score: " + str(ProgressTracking.best_score)


func _on_RestartButton_pressed():
	ProgressTracking.reset()
	get_tree().change_scene("res://Game/Game.tscn")
