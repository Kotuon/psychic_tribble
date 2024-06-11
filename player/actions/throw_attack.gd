extends Attack

const SPEAR := preload("res://objects/projectiles/spear.tscn")
@export var start_ran : bool = false
var has_released : bool = false

@onready var target_hitbox = $Target_Area/Target_Hitbox

var target = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if !start_ran || has_released:
        return

    var direction = parent.get_animation_direction(parent.last_non_zero_input)
    update_target_rotation(direction)
    parent.animation_player.play(direction + "_throw_update")


func start() -> bool:
    if is_running:
        return false

    if !super.start():
        return false

    parent.can_walk = false
    is_running = true

    var direction = parent.get_animation_direction(parent.last_non_zero_input)

    parent.animation_player.play(direction + "_throw_start", -1, 2.0)
    play_sound(0.0)

    return true

func update_target() -> void:
    target = null
    var overlapped_hits = $Target_Area.get_overlapping_bodies()
    for hit in overlapped_hits:
        if hit is CharacterBase && hit != parent:
            target = hit

func trigger_release() -> void:
    if !is_running:
        return
    
    if !start_ran:
        end()
        return

    has_released = true
    var direction = parent.get_animation_direction(parent.last_non_zero_input)
    parent.animation_player.play(direction + "_throw_end")

func throw_spear() -> void:
    var this_spear = SPEAR.instantiate()
    parent.get_parent().add_child(this_spear)
    
    update_target()
    this_spear.target = target
    
    var input_direction = parent.last_non_zero_input
    this_spear.position = parent.position + (input_direction * 80.0)
    this_spear.rotation = get_angle_to((input_direction * 80) + parent.position)
    
    this_spear.launch(input_direction, 200.0)

func end() -> void:
    is_running = false
    parent.can_walk = true
    start_ran = false
    has_released = false

    super.end()

func update_target_rotation(direction: String) -> void:
    match direction:
        "front":
            target_hitbox.rotation = PI
        "front_side":
            if parent.sprite.flip_h == false:
                target_hitbox.rotation = 3*PI/4.0
            else:
                target_hitbox.rotation = -3*PI/4.0
        "back":
            target_hitbox.rotation = 0
        "back_side":
            if parent.sprite.flip_h == false:
                target_hitbox.rotation = PI/4.0
            else:
                target_hitbox.rotation = -PI/4.0
        "side":
            if parent.sprite.flip_h == false:
                target_hitbox.rotation = PI/2.0
            else:
                target_hitbox.rotation = -PI/2.0

func check_overlapping():
    var overlapped_hits = target_hitbox.get_overlapping_bodies()
    for hit in overlapped_hits:
        if hit is CharacterBase && hit != parent:
            target = hit
