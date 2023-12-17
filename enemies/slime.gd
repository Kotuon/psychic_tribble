extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    max_walk_speed = 350

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

func freeze_movement():
    can_walk = false

func unfreeze_movement():
    can_walk = true
