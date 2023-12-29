extends Sprite2D

@export var time_to_fade = 0.25
@export var start_value = 0.4
var counter = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    counter += delta
    var t = counter / time_to_fade
    modulate.a = start_value * (1.0 - t)

    if t > 1.0:
        queue_free()
