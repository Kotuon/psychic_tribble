extends Node2D
class_name Wall

@onready var collision_area : CollisionShape2D = $StaticBody2D/CollisionShape2D
@export var collision_enabled := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    collision_area.set_disabled(!collision_enabled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func enable_collision():
    collision_area.set_disabled(false)
