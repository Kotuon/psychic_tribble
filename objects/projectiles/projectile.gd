extends CharacterBody2D
class_name Projectile

@export var lifetime = 1.0
var curr_lifetime : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    velocity = Vector2.ZERO
    curr_lifetime = lifetime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    curr_lifetime -= delta
    if curr_lifetime <= 0.0:
        queue_free()

    move_and_slide()

func launch(direction: Vector2, speed: float) -> void:
    velocity = direction * speed
