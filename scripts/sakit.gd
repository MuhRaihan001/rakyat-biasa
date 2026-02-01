extends CharacterBody2D
@export var dialogue_ui: Control 
@onready var dialogue_objective: Control = $"../UI_layer/dialogue_objective"
@onready var player: Player = $"../Player"
# --- IMPORTANT SETUP ---
# 1. Rename this to match your exact node name in the Scene Tree.
#    Most likely it is "AnimatedSprite2D" or "Sprite2D".
# 2. Ensure this node is a direct child of the NPC root.
@onready var anim_sprite = $AnimatedSprite2D
var player_ref: Node2D = null
func _ready():
	$ChatDetectionArea.body_entered.connect(_on_chat_detection_area_body_entered)
	$ChatDetectionArea.body_exited.connect(_on_chat_detection_area_body_exited)

func _process(_delta):
	if player_ref:
		# 1. FACE THE PLAYER (4 Directions)
		face_player_4_dir()
		
		# 2. CHECK INPUT
		if Input.is_action_just_pressed("ui_accept"):
				run_dialogue()

func face_player_4_dir():
	if player_ref == null: return
	
	# Get vector pointing from NPC to Player
	var direction = (player_ref.global_position - global_position)
	
	# We use 'abs' to see if the horizontal distance is bigger than the vertical distance
	if abs(direction.x) > abs(direction.y):
		# Horizontal Priority (Left or Right)
		if direction.x > 0:
			play_anim("idle_right") # Or flip_h = false
		else:
			play_anim("idle_left")  # Or flip_h = true
	else:
		# Vertical Priority (Up or Down)
		if direction.y > 0:
			play_anim("idle_down")
		else:
			play_anim("idle_up")

func play_anim(anim_name: String):
	# Safety check: ensure the animation exists before trying to play it
	if anim_sprite and anim_sprite.sprite_frames.has_animation(anim_name):
		anim_sprite.play(anim_name)

func run_dialogue():
	if player.is_have_herb:
		dialogue_objective.start('res://dialogs/type3_akhir.json')
		player.finish_type3 = true
	else:
		dialogue_objective.start('res://dialogs/type3_awal.json')
		player.is_have_herb = false
	
func _on_chat_detection_area_body_entered(body):
	if body.name == "Player": 
		player_ref = body

func _on_chat_detection_area_body_exited(body):
	if body.name == "Player":
		player_ref = null
