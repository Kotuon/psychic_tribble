extends Node2D
class_name Ability

var parent : CharacterBase

var action_id : int

@export var can_override = false
@export var can_queue = false
@export var cooldown = 1.0
var is_running = false

@onready var cooldown_timer = $Cooldown
var on_cooldown = false

@export var sound_effects : Array[AudioStream]
@onready var ability_audioplayer = $Ability_AudioPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    parent = get_owner()
    cooldown_timer.wait_time = cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func _input(_event: InputEvent) -> void:
    pass

func start() -> bool:
    if on_cooldown:
        return false

    if parent.current_action != -1 && parent.current_action != action_id:
        if parent.ability_list[parent.current_action].is_running:
            if can_queue:
                parent.queued_action = action_id
            return false

    return true

func end() -> void:
    on_cooldown = true
    cooldown_timer.start()
    if parent.queued_action != -1:
        parent.change_action(parent.queued_action)
        parent.queued_action = -1

func play_sound(_start_position: float) -> void:
    pass

func _on_cooldown_timeout() -> void:
    on_cooldown = false
