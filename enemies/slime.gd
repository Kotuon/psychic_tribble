extends Enemy

@onready var chase = $Chase
@onready var idle = $Idle
@onready var attack = $Attack

@onready var navigation = $NavigationAgent2D
var next_position : Vector2

@export var attack_distance = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

func _physics_process(delta: float) -> void:
    super._physics_process(delta)
    next_position = navigation.get_next_path_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

    if is_stunned:
        if current_action != idle.action_id:
            change_action(idle.action_id)
        return

    var result = false

    navigation.target_position = player.position
    if distance_from_player < attack_distance:
        result = change_action(attack.action_id)

    if !result && can_see_player && current_action != chase.action_id:
        result = change_action(chase.action_id)

    if !result:
        result = change_action(idle.action_id)

func freeze_movement():
    can_walk = false

func unfreeze_movement():
    can_walk = true

func get_animation_direction(direction : Vector2) -> StringName:
    var animation_direction = "front"

    if abs(direction.y) > abs(direction.x):
        if direction.y > 0.0:
            animation_direction = "front"
        elif direction.y < 0.0:
            animation_direction = "back"
    else:
        if direction.x > 0.0:
            sprite.flip_h = false
            animation_direction = "side"
        elif direction.x < 0.0:
            sprite.flip_h = true
            animation_direction = "side"

    return animation_direction
