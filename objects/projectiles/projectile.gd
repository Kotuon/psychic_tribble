extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    velocity = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    move_and_slide()

func launch(direction: Vector2, speed: float) -> void:
    velocity = direction * speed
