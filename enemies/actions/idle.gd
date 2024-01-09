extends Ability

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

    is_running = true

    var animation_direction = parent.get_animation_direction(parent.last_non_zero_input)
    parent.animation_player.play(animation_direction + "_idle")

    return true

func end() -> void:
    super.end()
