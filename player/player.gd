extends CharacterBase
class_name Player

var most_recent_checkpoint : Node2D

@onready var dash = $Dash
@onready var slash = $Slash
@onready var stab = $Stab

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
        change_action(dash.action_id)

    if event.is_action_pressed("slash"):
        change_action(slash.action_id)

    if event.is_action_pressed("stab"):
        change_action(stab.action_id)

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
