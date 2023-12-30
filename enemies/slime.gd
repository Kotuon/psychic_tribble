extends Enemy

enum Actions {Idle, Chase, Attack, Stunned }
var current_action = Actions.Idle

@onready var idle = $Idle
@onready var chase = $Chase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    for child in get_children():
        if child is Ability:
            ability_list.push_back(child)

func _physics_process(delta: float) -> void:
    super._physics_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

    if can_see_player:
        current_action = Actions.Chase

    match current_action:
        Actions.Idle:
            idle.start()
        Actions.Chase:
            chase.start()
        Actions.Attack:
            pass

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
