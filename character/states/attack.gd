extends Ability

@export var attack_damage = 1
@onready var attack_hitbox = $Attack_Area/Attack_Hitbox
@onready var attack_area = $Attack_Area
var attack_number = 0
var is_combo = false

var can_take_damage = true
var in_hazard = false

var hit_enemies : Array[CharacterBody2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    if is_running:
        pass

func start() -> bool:
    if (!super.start()):
        return false

    attack_hitbox.disabled = false
    if is_running && attack_number == 0:
        is_combo = true
    elif !is_running && attack_number == 0:
        parent.can_walk = false
        is_running = true

        hit_enemies.clear()
        check_overlapping()

        var direction = parent.get_animation_direction(parent.last_non_zero_input)
        update_hitbox_position(direction)
        parent.animation_player.play(direction + "_slash_first")
        play_sound()

    return true

func end() -> void:
    if attack_number == 0 && is_combo:
        attack_number += 1

        hit_enemies.clear()
        check_overlapping()

        var direction = parent.get_animation_direction(parent.last_non_zero_input)
        update_hitbox_position(direction)
        parent.animation_player.play(direction + "_slash_second")
        play_sound()
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

func check_overlapping():
    var overlapped_hits = $Attack_Area.get_overlapping_bodies()
    for hit in overlapped_hits:
        if hit is Enemy:
            hit_enemies.push_back(hit)
            hit.take_damage(attack_damage)

func _on_attack_area_body_entered(body: Node2D) -> void:
    if body is Enemy:
        hit_enemies.push_back(body)
        body.take_damage(attack_damage)

func update_hitbox_position(direction: String) -> void:
    match direction:
        "front":
            attack_area.rotation = 0
            attack_area.position = Vector2(0.0, 40.0)
        "front_side":
            if parent.sprite.fliph == false:
                attack_area.rotation = -PI/4.0
                attack_area.position = Vector2(28.0, 28.0)
            else:
                attack_area.rotation = PI/4.0
                attack_area.position = Vector2(-28.0, 28.0)
        "back":
            attack_area.rotation = 0
            attack_area.position = Vector2(0.0, -40.0)
        "back_side":
            if parent.sprite.fliph == false:
                attack_area.rotation = -PI/4.0
                attack_area.position = Vector2(28.0, 28.0)
            else:
                attack_area.rotation = PI/4.0
                attack_area.position = Vector2(-28.0, 28.0)
        "side":
            attack_area.rotation = PI/2.0
            if parent.sprite.fliph == false:
                attack_area.position = Vector2(40.0, 0.0)
            else:
                attack_area.position = Vector2(-40.0, 0.0)
