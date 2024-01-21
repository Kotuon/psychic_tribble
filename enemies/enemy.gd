extends CharacterBase
class_name Enemy

# Player information
var player : Node2D
var can_see_player = false
var distance_from_player : float

@export var look_for_player : bool = true

func _ready() -> void:
    super._ready()
    player = get_node("../player")

func _physics_process(_delta: float) -> void:
    if !look_for_player:
        return

    var space_state = get_world_2d().direct_space_state
    var query_for_player = PhysicsRayQueryParameters2D.create(position, player.position)
    var quety_result = space_state.intersect_ray(query_for_player)

    can_see_player = false
    if quety_result:
        if quety_result.collider is Player:
            can_see_player = true

func _process(delta: float) -> void:
    super._process(delta)
    distance_from_player = position.distance_to(player.position)

func kill():
    super.kill()
