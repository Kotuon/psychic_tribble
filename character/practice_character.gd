extends CharacterBase

func _ready() -> void:
    super._ready()

func _process(delta: float) -> void:
    super._process(delta)

func take_damage(damage: int) -> void:
    health += damage
    super.take_damage(damage)

    animation_player.play("hit")

func end_hit() -> void:
    animation_player.play("idle")
