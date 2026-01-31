extends Control

@export_file("*.json") var d_file
@onready var player: Player = $"../../Player"

var dialogue = []
var curr_dialogue_id = 0
var d_active = false

signal dialogue_finish

func _ready() -> void:	
	$NinePatchRect.visible = false

func start():
	if d_active:
		return
	
	# 1. Assign the returned JSON data to the 'dialogue' variable
	if player.is_have_money:
		dialogue = load_dialogue_t()
	else:
		dialogue = load_dialogue_f()
	
	# 2. Safety check: did the file actually load anything?
	if dialogue == null or dialogue.size() == 0:
		print("Error: Dialogue file is empty or failed to load!")
		return

	d_active = true
	player.is_can_move = false
	curr_dialogue_id = -1
	$NinePatchRect.visible = true
	next_script()

# Simplified loading functions to return the parsed data
func load_dialogue_f():
	var path = "res://dialogs/objective_dialogue_f.json"
	var file = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(file.get_as_text())
	
func load_dialogue_t():
	var path = "res://dialogs/objective_dialogue_t.json"
	var file = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(file.get_as_text())

func _input(event: InputEvent) -> void:
	if !d_active:
		return
	
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled() 
		next_script()

func next_script():
	curr_dialogue_id += 1
	
	if curr_dialogue_id >= dialogue.size():
		finish_dialogue()
		return
	
	$NinePatchRect/name.text = dialogue[curr_dialogue_id]['name']
	$NinePatchRect/text_dialogue.text = dialogue[curr_dialogue_id]['text']

func finish_dialogue():
	$NinePatchRect.visible = false
	await get_tree().create_timer(0.1).timeout 
	d_active = false
	curr_dialogue_id = 0
	player.is_can_move = true
	emit_signal("dialogue_finish")
