extends Node2D
class_name Ability

var parent : Player

@export var cooldown : float
var is_running = false
var counter : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    parent = get_owner()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if counter > 0:
        counter -= delta

func start() -> bool:
    if counter > 0:
        return false

    return true

func update(_delta: float) -> void:
    pass

func end() -> void:
    counter = cooldown
