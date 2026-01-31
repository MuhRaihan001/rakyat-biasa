extends CharacterBody2D

# Tracks if player is in the zone
var player_in_chat_zone: bool = false
# Store a reference to the player object while they are in the zone
var player_ref: Node2D = null

func _ready():
	$ChatDetectionArea.body_entered.connect(_on_chat_detection_area_body_entered)
	$ChatDetectionArea.body_exited.connect(_on_chat_detection_area_body_exited)

func _process(_delta):
	if player_in_chat_zone and player_ref:
		if Input.is_action_just_pressed("ui_accept"):
			toggle_player_money()

func toggle_player_money():
	# Use "not" to flip the boolean (true becomes false, false becomes true)
	if "is_have_money" in player_ref:
		player_ref.is_have_money = !player_ref.is_have_money
		print("Player money status changed to: ", player_ref.is_have_money)
	else:
		print("Error: 'is_have_money' variable not found on Player script!")

# --- Signal Functions ---

func _on_chat_detection_area_body_entered(body):
	if body.name == "Player": 
		player_in_chat_zone = true
		player_ref = body # Store the reference to the player node
		print("Player nearby - Press 'Accept' to toggle money")

func _on_chat_detection_area_body_exited(body):
	if body.name == "Player":
		player_in_chat_zone = false
		player_ref = null # Clear the reference when they leave
