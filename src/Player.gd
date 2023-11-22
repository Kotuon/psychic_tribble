extends CharacterBody2D

@export var size : float

#Walk
@export var max_walk_speed = 350
@export var walk_acceleration = 600
@export var brake_speed = 1250
@export var turn_speed = 10000

var current_walk_speed = 0
var can_walk = true

#Dash
@export var time_to_dash = 0.2
@export var dash_distance = 200

var dash_direction : Vector2
var time_since_dash_started = 0.0
var is_dashing = false

# Attack
var attack_damage = 10
@export var is_attacking = false

var can_take_damage = true

# Animations
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

func _draw():
    pass
    #draw_rect(Rect2(-size/2,-size/2,size, size), Color.SPRING_GREEN)

# Called when the node enters the scene tree for the first time.
func _ready():
    animation_player.play("front_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    walk(delta)
    dash(delta)

func _input(event: InputEvent):
    if event.is_action_pressed("dash"):
        start_dash()
    
    if event.is_action_pressed("attack"):
        can_walk = false
        is_attacking = true

        var animation_direction = get_animation_direction(velocity)
        animation_player.play(animation_direction + "_slash_first")

func end_attack():
    is_attacking = false
    can_walk = true

func update_current_walk_speed(delta, direction : Vector2):
    if direction.length_squared() > 0.0:
        if current_walk_speed < max_walk_speed:
            current_walk_speed += walk_acceleration * delta
        else:
            current_walk_speed = max_walk_speed
    else:
        if current_walk_speed > 0.0:
            current_walk_speed -= brake_speed * delta
        else:
            current_walk_speed = 0.0

func get_animation_direction(direction : Vector2) -> StringName:
    var animation_direction = "front"

    if direction.y > 0.0:
        if direction.x == 0.0:
            animation_direction = "front"
        else:
            if direction.x > 0.0:
                sprite.flip_h = false
                animation_direction = "front_side"
            elif direction.x < 0.0:
                sprite.flip_h = true
                animation_direction = "front_side"
    elif direction.y < 0.0:
        if direction.x == 0.0:
            animation_direction = "back"
        else:
            if direction.x > 0.0:
                sprite.flip_h = false
                animation_direction = "back_side"
            elif direction.x < 0.0:
                sprite.flip_h = true
                animation_direction = "back_side"
    else:
        if direction.x > 0.0:
            sprite.flip_h = false
            animation_direction = "side"
        elif direction.x < 0.0:
            sprite.flip_h = true
            animation_direction = "side"

    return animation_direction

func walk(delta):
    if !can_walk:
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    update_current_walk_speed(delta, direction)
    if velocity.normalized() == (direction.normalized() * -1.0):
        direction += (direction.orthogonal() * turn_speed)
    velocity = (velocity + (direction * turn_speed)).normalized() * current_walk_speed

    var animation_direction = get_animation_direction(velocity)

    if current_walk_speed == 0.0:
        animation_player.play("front_idle")
    elif current_walk_speed < 200:
        animation_player.play(animation_direction + "_walk")
    else:
        animation_player.play(animation_direction + "_run")
    move_and_slide()

func start_dash():
    can_walk = false
    is_dashing = true
    can_take_damage = false
    time_since_dash_started = 0.0
    dash_direction = (get_viewport().get_mouse_position() - position).normalized()

    animation_player.play(get_animation_direction(dash_direction) + "_dash")

    velocity = dash_direction * (dash_distance / time_to_dash)

func dash(delta):
    if !is_dashing:
        return

    time_since_dash_started += delta
    move_and_slide()

    if time_since_dash_started > time_to_dash:
        can_walk = true
        is_dashing = false
        can_take_damage = true
        velocity = Vector2.ZERO
        current_walk_speed = 0.0
