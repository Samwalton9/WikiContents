extends Control

var page_data = {}
var rng = RandomNumberGenerator.new()
var selected_page = ""

const heading = preload("res://Game/Heading.tscn")
const articleButton = preload("res://Game/ArticleButton.tscn")

onready var headingsVBox = $Container/HeadingsVBox
onready var headingNumbersVBox = $Container/HeadingNumbersVBox
onready var answerGrid = $AnswerGrid
onready var scoreAnimationPlayer = $Score/AnimationPlayer


func _ready():
	var file = File.new()
	file.open("res://Scripts/interesting_pages.json", File.READ)
	page_data = parse_json(file.get_as_text())

	selected_page = get_random_page_not_in_list(page_data, ProgressTracking.pages_seen)
	var sections = page_data[selected_page]

	for section_number in sections.size():
		var heading_entry = heading.instance()
		headingsVBox.add_child(heading_entry)

		var section = sections[section_number]
		heading_entry.set_heading_text(section)

		var heading_number = heading.instance()
		headingNumbersVBox.add_child(heading_number)
		heading_number.set_heading_text(str(section_number+1))
		heading_number.set_label_color(Color(0,0,0))

	# Generate list of options, including correct answer, without duplicates
	var answer_options = [selected_page]
	for i in range(7):
		var rand_page = get_random_page_not_in_list(page_data, answer_options)

		answer_options.append(rand_page)
	answer_options.shuffle()

	for answer_option in answer_options:
		var new_button = articleButton.instance()
		answerGrid.add_child(new_button)
		new_button.set_label_text(answer_option)

	ProgressTracking.pages_seen.append(selected_page)

	Events.connect("button_pressed", self, "_on_answer_pressed")


func get_random_key(dictionary):
	rng.randomize()
	var keys = dictionary.keys()

	return keys[rng.randi() % keys.size()]


func _on_answer_pressed(page_title):
	if page_title == selected_page:
		$Score.increase_score()
	else:
		$Lives.decrease_lives()

func get_random_page_not_in_list(page_json, avoid_list):
	var find_new_title = true
	var rand_page_title = ""

	while find_new_title:
		rand_page_title = get_random_key(page_json)
		if not rand_page_title in avoid_list:
			find_new_title = false

	return rand_page_title

