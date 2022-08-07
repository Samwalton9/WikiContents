extends Label

onready var animationPlayer = $AnimationPlayer

func _ready():
	rect_pivot_offset = rect_size/2
	update_lives_text()

func update_lives_text():
	text = "Lives: " + str(ProgressTracking.lives)

func decrease_lives():
	ProgressTracking.lives -= 1
	animationPlayer.play("LivesDown")
	update_lives_text()
