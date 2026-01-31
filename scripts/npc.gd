extends CharacterBody2D

# 1. This variable lets you drag and drop your Dialogue UI node 
# into the NPC inspector later.
@export var dialogue_ui: Control 

# 2. Tracks if player is in the zone
var player_in_chat_zone: bool = false

func _ready():
	# Connect the signals from the Area2D via code 
	# (Or you can do this via the Node tab in the editor)
	$ChatDetectionArea.body_entered.connect(_on_chat_detection_area_body_entered)
	$ChatDetectionArea.body_exited.connect(_on_chat_detection_area_body_exited)

func _process(_delta):
	if player_in_chat_zone:
		# is_action_just_pressed is better than is_action_pressed for NPCs
		if Input.is_action_just_pressed("ui_accept"):
			# Only start if the UI is NOT active
			if dialogue_ui and dialogue_ui.d_active == false:
				run_dialogue()

func run_dialogue():
	if dialogue_ui:
		# Check if dialogue is already active to prevent restarting it
		if dialogue_ui.d_active:
			return
			
		dialogue_ui.start()
	else:
		print("Error: Dialogue UI not assigned to NPC!")

# --- Signal Functions ---

func _on_chat_detection_area_body_entered(body):
	# Assuming your player script acts as a CharacterBody2D. 
	# Better practice: Check if body.is_in_group("player")
	if body.name == "Player": 
		player_in_chat_zone = true
		print("Player nearby") # Debug print

func _on_chat_detection_area_body_exited(body):
	if body.name == "Player":
		player_in_chat_zone = false
