extends CharacterBase
class_name Player

var most_recent_checkpoint : Node2D

@onready var camera = $Camera2D

@onready var dash = $Dash
@onready var slash = $Slash
@onready var stab = $Stab

@onready var mask = $Mask

@onready var pause_menu = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()
    pause_menu.hide()
    animation_player.play("front_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    super._process(delta)
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    walk(delta, direction)

    mask.texture = sprite.texture
    mask.hframes = sprite.hframes
    mask.vframes = sprite.vframes
    mask.flip_h = sprite.flip_h
    mask.frame = sprite.frame

func _input(event: InputEvent):
    if event.is_action_pressed("dash"):
        change_action(dash.action_id)

    if event.is_action_pressed("slash"):
        if current_action == dash.action_id:
            queued_action = stab.action_id
        else:
            change_action(slash.action_id)

    if event.is_action_pressed("pause"):
        if !get_tree().paused:
            get_tree().paused = true
            pause_menu.show()
            set_physics_process(false)

    if event.is_action_pressed("shake_test"):
        camera.add_trauma(1.0)

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

func _on_resume_pressed() -> void:
    pause_menu.hide()
    get_tree().paused = false
    set_physics_process(true)


func _on_quit_pressed() -> void:
    get_tree().quit()
