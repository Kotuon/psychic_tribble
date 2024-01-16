extends Projectile

@export var scale_factor = 6.0
@export var damage = 1

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

    scale.y += (scale_factor * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "player":
        if body.can_take_damage:
            body.take_damage(damage)
