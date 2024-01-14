extends Attack

var original_damage : int
var attack_number = 0
var is_combo = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    original_damage = attack_damage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    if is_running:
        pass

func start() -> bool:
    if !super.start():
        return false

    attack_hitbox.disabled = false
    if is_running:
        is_combo = true
    elif !is_running && attack_number == 0:
        parent.can_walk = false
        is_running = true

        hit_enemies.clear()
        check_overlapping()

        var direction = parent.get_animation_direction(parent.last_non_zero_input)
        update_hitbox_position(direction)
        parent.animation_player.play(direction + "_slash_first")
        play_sound(0.3)

    return true

func end() -> void:
    if attack_number == 0 && is_combo:
        attack_number += 1
        attack_damage = original_damage * 2

        hit_enemies.clear()
        check_overlapping()

        var direction = parent.get_animation_direction(parent.last_non_zero_input)
        update_hitbox_position(direction)
        parent.animation_player.play(direction + "_slash_second")
        play_sound(0.3)
        is_combo = false
        return

    if attack_number == 1 && is_combo:
        parent.queued_action = parent.stab.action_id

    attack_damage = original_damage
    is_running = false
    parent.can_walk = true
    attack_number = 0
    attack_hitbox.disabled = true
    parent.current_walk_speed = 0
    super.end()
