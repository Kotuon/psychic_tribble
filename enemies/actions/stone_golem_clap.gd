extends Attack

var chance = 50
var chance_change = 10
var chance_min = 20
var chance_max = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    longest_side = attack_hitbox.shape.size.x/2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

func update_hitbox_position(_direction: String) -> void:
    pass

func start() -> bool:
    if (!super.start()):
        return false

    attack_hitbox.disabled = false
    hit_enemies.clear()

    parent.animation_player.play("attack")

    return true

func end() -> void:
    super.end()
    attack_hitbox.call_deferred("set_disabled", true)
    parent.start_wait_timer()

func spawn_projectile():
    var new_projectile = preload("res://objects/projectiles/golem_clap_projectile.tscn").instantiate()
    parent.get_parent().add_child(new_projectile)

    var world_scale = parent.get_parent().scale
    
    var direction_to_player = (parent.player.position - parent.position).normalized()
    new_projectile.global_rotation = direction_to_player.angle()

    new_projectile.position = parent.position + (direction_to_player * 150.0 / world_scale.x)
    new_projectile.launch(direction_to_player, 400)

func play_ability_audio(start_time: float) -> void:
    ability_audioplayer.play(start_time)

func _on_attack_area_body_entered(_body: Node2D) -> void:
    pass
