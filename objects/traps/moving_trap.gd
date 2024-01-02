extends Node2D

@export var distance_to_move : float
@export var time_to_move : float
@export var start_delay : float

var current_direction = false
var time_since_start = 0.0

var start_position : Vector2
var end_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    start_position = position
    distance_to_move /= 2.0
    end_position = start_position + (global_transform.basis_xform(Vector2.RIGHT) * distance_to_move)
    #global_transform.basis_xform(Vector2.RIGHT)
    #end_position = Vector2(start_position.x + distance_to_move, start_position.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if start_delay > 0.0:
        start_delay -= delta
        return

    time_since_start += delta
    var t = time_since_start / time_to_move

    if t >= 1.0:
        current_direction = !current_direction
        time_since_start = 0.0
        return

    var new_position : Vector2
    if current_direction == false:
        new_position = (1-t)*start_position + t*end_position
    else:
        new_position = (1-t)*end_position + t*start_position

    position = new_position


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "player":
        if body.can_take_damage:
            body.kill()
