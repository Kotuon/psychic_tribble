extends Ability

@export var attack_damage = 1
var attack_hitbox : CollisionShape2D
var attack_number = 0
var is_combo = false

var can_take_damage = true
var in_hazard = false

var hit_enemies : Array[CharacterBody2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    attack_hitbox = get_node("Attack_Area/Attack_Hitbox")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

func start() -> bool:
    if (!super.start()):
        return false

    attack_hitbox.disabled = false
    if is_running && attack_number == 0:
        is_combo = true
    elif !is_running && attack_number == 0:
        parent.can_walk = false
        is_running = true
        parent.animation_player.play(parent.get_animation_direction(parent.last_non_zero_input) + "_slash_first")
        play_sound()
        hit_enemies.clear()


    return true

func update(delta: float) -> void:
    super.update(delta)

func end() -> void:
    if attack_number == 0 && is_combo:
        parent.animation_player.play(parent.get_animation_direction(parent.last_non_zero_input) + "_slash_second")
        play_sound()
        hit_enemies.clear()
        attack_number += 1
    else:
        super.end()
        is_running = false
        parent.can_walk = true
        attack_number = 0
        attack_hitbox.disabled = true
        parent.current_walk_speed = 0
        is_combo = false

func play_sound():
    if ability_audioplayer.is_playing():
        ability_audioplayer.stop()

    var random_index = parent.rng.randi_range(0,sound_effects.size() - 1)
    ability_audioplayer.stream = sound_effects[random_index]
    ability_audioplayer.play(0.3)


func _on_attack_area_body_entered(body: Node2D) -> void:
    if body is Enemy:
        hit_enemies.push_back(body)
        body.take_damage(attack_damage)
