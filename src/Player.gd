extends CharacterBody2D

@export var size : float

@export var max_walk_speed = 350
@export var walk_acceleration = 350
@export var brake_speed = 1000
@export var turn_speed = 25

var current_walk_speed = 0
var can_walk = true

@export var dash_speed = 5000
@export var time_to_dash = 0.1

var is_dashing = false
var dash_path : Vector2
var time_since_dash_started = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    walk(delta)
    dash(delta)

func _draw():
    draw_rect(Rect2(0.0,0.0,size, size), Color.SPRING_GREEN)

func walk(delta):
    if !can_walk:
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if direction.length_squared() > 0:
        if current_walk_speed < max_walk_speed:
            current_walk_speed += walk_acceleration * delta
        else:
            current_walk_speed = max_walk_speed
    else:
        if current_walk_speed > 0:
            current_walk_speed -= brake_speed * delta
        else:
            current_walk_speed = 0

    velocity = (velocity + (direction * turn_speed)).normalized() * current_walk_speed
    move_and_slide()

func dash(delta):
    if !Input.is_action_just_pressed("dash") and !is_dashing:
        return

    if !is_dashing:
        can_walk = false
        is_dashing = true
        time_since_dash_started = 0.0
        dash_path = (get_viewport().get_mouse_position() - position).normalized()
        velocity = dash_path * dash_speed
        print("Start Dash")
        return

    time_since_dash_started += delta
    move_and_slide()
    print("Continue Dash")

    if time_since_dash_started > time_to_dash:
        can_walk = true
        is_dashing = false
        velocity = Vector2.ZERO
        print("End Dash")

