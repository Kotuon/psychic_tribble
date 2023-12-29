extends CharacterBody2D
class_name CharacterBase

# Health
@export var health = 3

# Movement
@export var max_walk_speed = 350
@export var walk_acceleration = 600
@export var brake_speed = 1250
@export var turn_speed = 1000000
@export var run_cutoff = 200
@export var can_run = true

var last_non_zero_input = Vector2(0,1)
var current_walk_speed = 0
var can_walk = true

# Animations
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

# Audio
@onready var footstep_audioplayer = $Footstep_AudioPlayer
@onready var hit_audioplayer = $Hit_AudioPlayer
@export var footstep_sounds : Array[AudioStream]
@export var hit_sounds : Array[AudioStream]

#Abilities
var ability_list : Array[Ability]

# Random
var rng = RandomNumberGenerator.new()

func _ready() -> void:
    for child in get_children():
        if child is Ability:
            ability_list.push_back(child)

func update_current_walk_speed(delta, direction : Vector2):
    if direction.length_squared() > 0.0:
        if current_walk_speed < max_walk_speed:
            current_walk_speed += walk_acceleration * delta
        else:
            current_walk_speed = max_walk_speed
    else:
        if current_walk_speed > 0.0:
            current_walk_speed -= clamp(brake_speed * delta, 0.0, max_walk_speed)
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

func walk(delta: float, direction: Vector2) -> void:
    #var direction = (player.position - position).normalized()
    if direction.length_squared() > 0.0:
        last_non_zero_input = direction

    update_current_walk_speed(delta, direction)

    if !can_walk:
        return

    if velocity.normalized() == (direction.normalized() * -1.0):
        direction += (direction.orthogonal() * turn_speed)

    velocity = (velocity + (direction * turn_speed)).normalized() * current_walk_speed

    var animation_direction = get_animation_direction(velocity)

    if current_walk_speed == 0.0:
        animation_player.play(get_animation_direction(last_non_zero_input) + "_idle")
    else:
        play_footstep_sound()
        if can_run && current_walk_speed > run_cutoff:
            animation_player.play(animation_direction + "_run")
        else:
            animation_player.play(animation_direction + "_walk")
    move_and_slide()

func play_footstep_sound():
    if footstep_audioplayer.is_playing(): 
        return
    
    var random_index = rng.randi_range(0,footstep_sounds.size() - 1)
    footstep_audioplayer.stream = footstep_sounds[random_index]
    footstep_audioplayer.play()

func play_hit_sound():
    if hit_audioplayer.is_playing(): 
        return
    
    var random_index = rng.randi_range(0,hit_sounds.size() - 1)
    hit_audioplayer.stream = hit_sounds[random_index]
    hit_audioplayer.play()

