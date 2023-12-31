extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

func _physics_process(delta: float) -> void:
    super._physics_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

   # if can_see_player:
   #     change_action(Ability.Action.A_Chase)
    #else:
   #     change_action(Ability.Action.A_Idle)

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
