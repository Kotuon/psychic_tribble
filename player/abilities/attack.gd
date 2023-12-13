extends Ability

@export var attack_damage = 10
var attack_hitbox : CollisionShape2D
var attack_number = 0
var is_combo = false

var can_take_damage = true
var in_hazard = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    attack_hitbox = get_node("../Attack_Hitbox")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

func start() -> bool:
    if (!super.start()):
        return false

    attack_hitbox.disabled = false
    if is_running && attack_number == 0:
        is_combo = true
        print("IS_COMBO")
    else:
        parent.can_walk = false
        is_running = true
        parent.animation_player.play(parent.get_animation_direction(parent.velocity) + "_slash_first")

    return true

func update(delta: float) -> void:
    super.update(delta)

func end() -> void:
    if attack_number == 0 && is_combo:
        parent.animation_player.play(parent.get_animation_direction(parent.velocity) + "_slash_second")
        attack_number += 1
        print("COMBO")
    else:
        super.end()
        is_running = false
        parent.can_walk = true
        attack_number = 0

    is_combo = false
    parent.current_walk_speed = 0
    attack_hitbox.disabled = true
