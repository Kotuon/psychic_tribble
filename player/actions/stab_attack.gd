extends Attack

@export var distance = 100
@export var time_to_move = 0.2
@export var time_to_stun = 0.0
var can_move = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    if is_running:
        if can_move:
            parent.move_and_slide()

func start() -> bool:
    if !super.start():
        return false

    if is_running:
        return false

    attack_hitbox.disabled = false
    parent.can_walk = false
    is_running = true

    hit_enemies.clear()
    check_overlapping()

    var direction = parent.get_animation_direction(parent.last_non_zero_input)

    parent.velocity = parent.last_non_zero_input * (distance / time_to_move)
    can_move = true

    update_hitbox_position(direction)
    parent.animation_player.play(direction + "_stab")
    play_sound(0.0)

    return true

func end() -> void:
    is_running = false
    parent.can_walk = true
    attack_hitbox.disabled = true
    super.end()

func stop_movement() -> void:
    can_move = false

func deal_damage(body: Node2D) -> void:
    super.deal_damage(body)
    #body.stun(0.0)
