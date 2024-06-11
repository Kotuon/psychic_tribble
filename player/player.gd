extends CharacterBase
class_name Player

var most_recent_checkpoint : Node2D

#@onready var health_bar : ProgressBar = $Camera2D/GUI/Container/HealthBar

@onready var health_ticks : Array[AnimatedSprite2D] = [ $Camera2D/GUI/Container/HFlowContainer/Tick_0, $Camera2D/GUI/Container/HFlowContainer/Tick_1, $Camera2D/GUI/Container/HFlowContainer/Tick_2 ]

@onready var camera = $Camera2D

@onready var dash := $Dash
@onready var slash := $Slash
@onready var stab := $Stab
@onready var throw := $Throw

@onready var pause_menu := $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()

    #health_bar.set_max(max_health)
    #health_bar.set_value(curr_health)

    pause_menu.hide()
    animation_player.play("front_idle")
    
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    super._process(delta)
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    walk(delta, direction)

func _input(event: InputEvent):

    if event.is_action_pressed("slash"):
        if current_action == dash.action_id:
            queued_action = stab.action_id
        else:
            change_action(slash.action_id)

    if event.is_action_pressed("dash"):
        change_action(dash.action_id)

    if event.is_action_pressed("throw"):
        change_action(throw.action_id)
    if current_action == throw.action_id && event.is_action_released("throw"):
        throw.trigger_release()

    if event.is_action_pressed("pause"):
        if !get_tree().paused:
            Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
            get_tree().paused = true
            pause_menu.show()
            set_physics_process(false)

func kill():
    super.kill()

    current_walk_speed = 0.0
    play_hit_sound()

    if most_recent_checkpoint:
        print("Start at checkpoint.")
        position = most_recent_checkpoint.position
        curr_health = max_health
    else:
        print("No checkpoint.")
        get_tree().reload_current_scene()
        

func take_damage(damage: int) -> void:
    var curr_health_cpy = curr_health
    super.take_damage(damage)
    if curr_health_cpy != curr_health:
        health_ticks[curr_health].play("Hit")

func _on_resume_pressed() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    pause_menu.hide()
    get_tree().paused = false
    set_physics_process(true)

func _on_quit_pressed() -> void:
    get_tree().quit()
