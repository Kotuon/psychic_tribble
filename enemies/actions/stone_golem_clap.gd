extends Attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    longest_side = attack_hitbox.shape.size.x/2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

func update_hitbox_position(_direction: String) -> void:
    if parent.sprite.flip_h:
        attack_area.position = Vector2(-longest_side, 0)
    else:
        attack_area.position = Vector2(longest_side, 0)

func start() -> bool:
    if (!super.start()):
        return false

    update_hitbox_position("")
    parent.animation_player.play("attack")

    return true

func end() -> void:
    super.end()

func spawn_projectile():
    var new_projectile = preload("res://objects/projectiles/golem_clap_projectile.tscn").instantiate()
    parent.get_parent().add_child(new_projectile)

    var world_scale = parent.get_parent().scale
    
    var direction_to_player = (parent.player.position - parent.position).normalized()
    new_projectile.global_rotation = direction_to_player.angle()

    new_projectile.position = parent.position + (direction_to_player * 150.0 / world_scale.x)
    new_projectile.launch(direction_to_player, 400)
