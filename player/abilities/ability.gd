extends Node2D
class_name Ability

var parent : Player

@export var cooldown : float
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

func start() -> bool:
    if on_cooldown:
        return false

    return true

func update(_delta: float) -> void:
    pass

func end() -> void:
    on_cooldown = true
    cooldown_timer.start()

func play_sound():
    pass


func _on_cooldown_timeout() -> void:
    on_cooldown = false
