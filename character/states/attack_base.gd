extends Ability
class_name Attack

@export var attack_damage = 1
@onready var attack_hitbox = $Attack_Area/Attack_Hitbox
@onready var attack_area = $Attack_Area

var hit_enemies : Array[CharacterBody2D]

var diagonal_side : float
var longest_side : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    longest_side = attack_hitbox.shape.size.x/2.0 if attack_hitbox.shape.size.x > attack_hitbox.shape.size.y else attack_hitbox.shape.size.y/2.0
    diagonal_side = sqrt(pow(longest_side,2) / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    if is_running:
        pass

func start() -> bool:
    if (!super.start()):
        return false

    return true

func end() -> void:
    super.end()

func play_sound(start_position: float) -> void:
    if sound_effects.size() == 0:
        return
    
    if ability_audioplayer.is_playing():
        ability_audioplayer.stop()

    var random_index = parent.rng.randi_range(0,sound_effects.size() - 1)
    ability_audioplayer.stream = sound_effects[random_index]
    ability_audioplayer.play(start_position)

func check_overlapping():
    var overlapped_hits = $Attack_Area.get_overlapping_bodies()
    for hit in overlapped_hits:
        if hit is CharacterBase && hit != parent:
            hit_enemies.push_back(hit)
            deal_damage(hit)

func _on_attack_area_body_entered(body: Node2D) -> void:
    if body is CharacterBase && body != parent:
        hit_enemies.push_back(body)
        deal_damage(body)

func deal_damage(body: Node2D) -> void:
    body.take_damage(attack_damage)

func update_hitbox_position(direction: String) -> void:
    match direction:
        "front":
            attack_area.rotation = 0
            attack_area.position = Vector2(0.0, longest_side)
        "front_side":
            if parent.sprite.flip_h == false:
                attack_area.rotation = -PI/4.0
                attack_area.position = Vector2(diagonal_side, diagonal_side)
            else:
                attack_area.rotation = PI/4.0
                attack_area.position = Vector2(-diagonal_side, diagonal_side)
        "back":
            attack_area.rotation = 0
            attack_area.position = Vector2(0.0, -longest_side)
        "back_side":
            if parent.sprite.flip_h == false:
                attack_area.rotation = PI/4.0
                attack_area.position = Vector2(diagonal_side, -diagonal_side)
            else:
                attack_area.rotation = -PI/4.0
                attack_area.position = Vector2(-diagonal_side, -diagonal_side)
        "side":
            attack_area.rotation = PI/2.0
            if parent.sprite.flip_h == false:
                attack_area.position = Vector2(longest_side, 0.0)
            else:
                attack_area.position = Vector2(-longest_side, 0.0)
