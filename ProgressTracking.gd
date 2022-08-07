extends Node

const START_SCORE = 0
const START_LIVES = 3

onready var pages_seen = []

onready var score = START_SCORE
onready var lives = START_LIVES setget set_lives
onready var best_score = 0


func set_lives(new_lives):
	lives = new_lives

	if lives == 0:
		if score > best_score:
			best_score = score

		get_tree().change_scene("res://Menus/EndScreen.tscn")


func reset():
	pages_seen = []
	score = START_SCORE
	lives = START_LIVES
