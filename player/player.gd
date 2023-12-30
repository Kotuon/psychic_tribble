extends CharacterBase
class_name Player

# Abilities
@onready var dash = $Dash
@onready var attack = $Attack

# Attack
@onready var attack_hitbox = $Attack/Attack_Area/Attack_Hitbox
@onready var attack_area = $Attack/Attack_Area

# Taking damage
var can_take_damage = true
var in_hazard = false

var most_recent_checkpoint : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()
    animation_player.play("front_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    super._process(delta)
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    walk(delta, direction)

func _input(event: InputEvent):
    if event.is_action_pressed("dash"):
        dash.start()

    if event.is_action_pressed("attack"):
        attack.start()

func kill():
    super.kill()

    current_walk_speed = 0.0
    play_hit_sound()

    if most_recent_checkpoint:
        print("Start at checkpoint.")
        position = most_recent_checkpoint.position
    else:
        print("No checkpoint.")
        get_tree().reload_current_scene()
