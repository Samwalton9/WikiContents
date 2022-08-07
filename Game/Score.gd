extends Label

onready var animationPlayer = $AnimationPlayer

func _ready():
	rect_pivot_offset = rect_size/2
	update_score_text()

func update_score_text():
	text = "Score: " + str(ProgressTracking.score)

func increase_score():
	ProgressTracking.score += 1
	animationPlayer.play("ScoreUp")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ScoreUp":
		get_tree().reload_current_scene()
