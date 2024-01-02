extends Node2D

@export var time_to_float = 1.0
@export var left_right_variation = 1.0
@export var time_between_new_velocity = 0.1
@export var start_alpha = 1.0

var current_acceleration = Vector2.ZERO
var current_velocity = Vector2(0,-100)
var direction_counter = 0.0
var lifetime_counter : float

var speed = 250

# Random
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    lifetime_counter = time_to_float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if lifetime_counter <= 0.0:
        queue_free()
        
    var t = (1 - lifetime_counter) / time_to_float
    modulate.a = start_alpha * (1.0 - t)

    if direction_counter <= 0.0:
        var direction = left_right_variation
        if randi_range(0,1):
            direction = -left_right_variation
        current_acceleration = (Vector2(0,-1) + (Vector2(1,0) * direction)).normalized() * speed
        direction_counter = time_between_new_velocity

    current_velocity += current_acceleration * delta
    position += current_velocity * delta

    direction_counter -= delta
    lifetime_counter -= delta
