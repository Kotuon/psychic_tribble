extends CharacterBody2D
class_name Player

@export var size : float

#Walk
@export var max_walk_speed = 350
@export var walk_acceleration = 600
@export var brake_speed = 1250
@export var turn_speed = 1000000

var current_walk_speed = 0
var can_walk = true

#Abilities
@onready var dash = $Dash
@onready var attack = $Attack

# Attack
var attack_damage = 10
@export var is_attacking = false
var attack_number = 0
var is_combo = false
@onready var attack_hitbox = $Attack_Hitbox

var can_take_damage = true
var in_hazard = false

# Animations
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var most_recent_checkpoint : Node2D

func _draw():
    pass
    #draw_rect(Rect2(-size/2,-size/2,size, size), Color.SPRING_GREEN)

# Called when the node enters the scene tree for the first time.
func _ready():
    animation_player.play("front_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    walk(delta)

func _input(event: InputEvent):
    if event.is_action_pressed("dash"):
        dash.start()
        #start_dash()
    
    if event.is_action_pressed("attack"):
        attack.start()
#        attack_hitbox.disabled = false
#        if is_attacking && attack_number == 0:
#            is_combo = true
#        else:
#            can_walk = false
#            is_attacking = true
#
#            animation_player.play(get_animation_direction(velocity) + "_slash_first")

func start_can_combo():
    #can_combo = true
    pass

func end_attack():
    if attack_number == 0 && is_combo:
        animation_player.play(get_animation_direction(velocity) + "_slash_second")
        attack_number += 1
    else:
        is_attacking = false
        can_walk = true
        attack_number = 0

    is_combo = false
    current_walk_speed = 0
    attack_hitbox.disabled = true

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
    attack_hitbox.position = Vector2(0.0, 30.0)
    attack_hitbox.rotation = 0

    if direction.y > 0.0:
        if direction.x == 0.0:
            animation_direction = "front"
            attack_hitbox.position = Vector2(0.0, 30.0)
            attack_hitbox.rotation = 0
        else:
            if direction.x > 0.0:
                sprite.flip_h = false
                animation_direction = "front_side"
                attack_hitbox.position = Vector2(21.0, 21.0)
                attack_hitbox.rotation = -PI/4.0
            elif direction.x < 0.0:
                sprite.flip_h = true
                animation_direction = "front_side"
                attack_hitbox.position = Vector2(-21.0, 21.0)
                attack_hitbox.rotation = PI/4.0
    elif direction.y < 0.0:
        if direction.x == 0.0:
            animation_direction = "back"
            attack_hitbox.position = Vector2(0.0, -30.0)
            attack_hitbox.rotation = 0
        else:
            if direction.x > 0.0:
                sprite.flip_h = false
                animation_direction = "back_side"
                attack_hitbox.position = Vector2(21.0, -21.0)
                attack_hitbox.rotation = PI/4.0
            elif direction.x < 0.0:
                sprite.flip_h = true
                animation_direction = "back_side"
                attack_hitbox.position = Vector2(-21.0, -21.0)
                attack_hitbox.rotation = -PI/4.0
    else:
        if direction.x > 0.0:
            sprite.flip_h = false
            animation_direction = "side"
            attack_hitbox.position = Vector2(30.0, 0.0)
            attack_hitbox.rotation = PI/2.0
        elif direction.x < 0.0:
            sprite.flip_h = true
            animation_direction = "side"
            attack_hitbox.position = Vector2(-30.0, 0.0)
            attack_hitbox.rotation = PI/2.0

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

func kill():
    print("You have died.")
    if most_recent_checkpoint:
        print("Start at checkpoint.")
        position = most_recent_checkpoint.position
    else:
        print("No checkpoint.")
        get_tree().reload_current_scene()
