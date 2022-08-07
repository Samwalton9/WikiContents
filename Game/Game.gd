extends Control

var page_data = {}
var rng = RandomNumberGenerator.new()
var selected_page = ""

const heading = preload("res://Game/Heading.tscn")
const articleButton = preload("res://Game/ArticleButton.tscn")

onready var headingsVBox = $HeadingsVBox
onready var answerGrid = $AnswerGrid
onready var score = $Score
onready var lives = $Lives


func _ready():
	var file = File.new()
	file.open("res://Scripts/interesting_pages.json", File.READ)
	page_data = parse_json(file.get_as_text())

	selected_page = get_random_page_not_in_list(page_data, ProgressTracking.pages_seen)
	var sections = page_data[selected_page]

	for section in sections:
		var heading_entry = heading.instance()
		headingsVBox.add_child(heading_entry)

		heading_entry.set_heading_text(section)

	# Generate list of options, including correct answer, without duplicates
	var answer_options = [selected_page]
	for i in range(7):
		var rand_page = get_random_page_not_in_list(page_data, answer_options)

		answer_options.append(rand_page)
	answer_options.shuffle()

	# TODO: Button should be text on a blank button so it can overflow
	for answer_option in answer_options:
		var new_button = articleButton.instance()
		answerGrid.add_child(new_button)

		new_button.text = answer_option

		new_button.connect("pressed", self, "_on_answer_pressed", [answer_option])

	update_score_and_lives()

	ProgressTracking.pages_seen.append(selected_page)


func update_score_and_lives():
	# Set score and lives labels
	score.text = "Score: " + str(ProgressTracking.score)
	lives.text = "Lives: " + str(ProgressTracking.lives)


func get_random_key(dictionary):
	rng.randomize()
	var keys = dictionary.keys()

	return keys[rng.randi() % keys.size()]


func _on_answer_pressed(page_title):
	if page_title == selected_page:
		ProgressTracking.score += 1
		get_tree().reload_current_scene()
	else:
		ProgressTracking.lives -= 1

	update_score_and_lives()


func get_random_page_not_in_list(page_json, avoid_list):
	var find_new_title = true
	var rand_page_title = ""

	while find_new_title:
		rand_page_title = get_random_key(page_json)
		if not rand_page_title in avoid_list:
			find_new_title = false

	return rand_page_title
