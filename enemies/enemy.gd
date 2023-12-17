extends CharacterBody2D
class_name Enemy

var player : Node2D
var health = 3

#Walk
@export var max_walk_speed = 200
@export var walk_acceleration = 600
@export var brake_speed = 1250
@export var turn_speed = 1000000

var last_non_zero_input = Vector2(0,1)

var current_walk_speed = 0
var can_walk = true

# Attack
@onready var attack_hitbox = $Attack_Hitbox

# Animations
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

# Hit
@export var total_flicker_time = 0.8
var time_to_flicker : float
var is_flickering = false
var flicker_counter = 0.0
var flicker_amount = 4
var times_flickered = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player = get_node("../Player")
    time_to_flicker = total_flicker_time / flicker_amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    walk(delta)
    
    if is_flickering:
        flicker_counter += delta
        var t = flicker_counter / time_to_flicker

        if times_flickered % 2 == 0:
            modulate.a = 1 - t
        else:
            modulate.a = t

        if t > 1.0:
            times_flickered += 1
            flicker_counter = 0.0
        
        if times_flickered >= flicker_amount:
            is_flickering = false

func get_animation_direction(direction : Vector2) -> StringName:
    var animation_direction = "front"
    attack_hitbox.position = Vector2(0.0, 7.2)
    attack_hitbox.rotation = PI/2.0

    if abs(direction.y) > abs(direction.x):
        if direction.y > 0.0:
            animation_direction = "front"
            attack_hitbox.position = Vector2(0.0, 7.2)
            attack_hitbox.rotation = PI/2.0
        elif direction.y < 0.0:
            animation_direction = "back"
            attack_hitbox.position = Vector2(0.0, -7.2)
            attack_hitbox.rotation = PI/2.0
    else:
        if direction.x > 0.0:
            sprite.flip_h = false
            animation_direction = "side"
            attack_hitbox.position = Vector2(7.2, 0.0)
            attack_hitbox.rotation = 0
        elif direction.x < 0.0:
            sprite.flip_h = true
            animation_direction = "side"
            attack_hitbox.position = Vector2(-7.2, 0.0)
            attack_hitbox.rotation = 0

    return animation_direction

func kill():
    queue_free()

func take_damage(damage: int) -> void:
    health -= damage

    is_flickering = true
    flicker_counter = 0.0
    times_flickered = 0

    if health <= 0:
        kill()

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

func walk(delta):
    if !can_walk:
        return

    var direction = (player.position - position).normalized()
    if direction.length_squared() > 0.0:
        last_non_zero_input = direction

    update_current_walk_speed(delta, direction)
    if velocity.normalized() == (direction.normalized() * -1.0):
        direction += (direction.orthogonal() * turn_speed)

    velocity = (velocity + (direction * turn_speed)).normalized() * current_walk_speed

    var animation_direction = get_animation_direction(velocity)

    if current_walk_speed == 0.0:
        animation_player.play(get_animation_direction(last_non_zero_input) + "_idle")
    else:
        animation_player.play(animation_direction + "_walk")
        #play_footstep_sound()
    move_and_slide()
